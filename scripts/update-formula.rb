#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "net/http"
require "optparse"
require "timeout"
require "uri"

class FormulaUpdateError < StandardError; end

class FormulaUpdater
  TAG_PATTERN = /\Av?\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\z/
  SHA256_PATTERN = /\A[0-9a-f]{64}\z/
  MAX_REDIRECTS = 5

  def initialize(options)
    @config_path = options.fetch(:config_path)
    @formula_path_override = options[:formula_path]
    @tag = options.fetch(:tag)
    @sha256 = options[:sha256]
  end

  def run
    validate_tag!
    validate_sha256! if @sha256
    config = load_config
    url = source_url(config)
    sha256 = @sha256 || sha256_for(url)
    formula_path = @formula_path_override || config.fetch("formula_path")
    write_formula(formula_path, render_formula(config, url, sha256))
    puts "Updated #{formula_path} for #{@tag}"
    puts "Source URL: #{url}"
    puts "SHA-256: #{sha256}"
  end

  private

  def validate_tag!
    return if @tag.match?(TAG_PATTERN)

    raise FormulaUpdateError,
          "release tag must look like a semver tag, for example v0.1.0: #{@tag.inspect}"
  end

  def validate_sha256!
    return if @sha256.match?(SHA256_PATTERN)

    raise FormulaUpdateError, "sha256 must be 64 lowercase hexadecimal characters: #{@sha256.inspect}"
  end

  def load_config
    JSON.parse(File.read(@config_path)).tap do |config|
      required_keys = %w[
        formula_path
        class_name
        binary_name
        desc
        homepage
        source_url_template
        license
        build_dependencies
        dependencies
        test_args
      ]
      missing = required_keys.reject { |key| config.key?(key) }
      raise FormulaUpdateError, "missing config keys: #{missing.join(", ")}" unless missing.empty?

      unless config.fetch("source_url_template").include?("%{tag}")
        raise FormulaUpdateError, "source_url_template must include %{tag}"
      end
    end
  rescue JSON::ParserError => e
    raise FormulaUpdateError, "invalid JSON in #{@config_path}: #{e.message}"
  end

  def source_url(config)
    config.fetch("source_url_template").sub("%{tag}", @tag)
  end

  def sha256_for(url)
    Digest::SHA256.hexdigest(fetch(url))
  end

  def fetch(url, redirects = 0)
    raise FormulaUpdateError, "too many redirects while fetching #{url}" if redirects > MAX_REDIRECTS

    uri = URI(url)
    unless uri.is_a?(URI::HTTPS)
      raise FormulaUpdateError, "source archive URL must use https: #{url}"
    end

    Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 15, read_timeout: 120) do |http|
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "homebrew-atctl-formula-updater"
      response = http.request(request)

      case response
      when Net::HTTPSuccess
        response.body
      when Net::HTTPRedirection
        location = response["location"]
        raise FormulaUpdateError, "redirect without location while fetching #{url}" if location.nil?

        fetch(URI.join(uri, location).to_s, redirects + 1)
      else
        raise FormulaUpdateError, "failed to fetch #{url}: HTTP #{response.code} #{response.message}"
      end
    end
  rescue SocketError, SystemCallError, Timeout::Error => e
    raise FormulaUpdateError, "failed to fetch #{url}: #{e.class}: #{e.message}"
  end

  def write_formula(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def render_formula(config, url, sha256)
    lines = []
    lines << "class #{config.fetch("class_name")} < Formula"
    lines << "  desc #{ruby_string(config.fetch("desc"))}"
    lines << "  homepage #{ruby_string(config.fetch("homepage"))}"
    lines << "  url #{ruby_string(url)}"
    lines << "  sha256 #{ruby_string(sha256)}"
    lines << "  license #{ruby_string(config.fetch("license"))}"
    lines << ""

    config.fetch("build_dependencies").each do |dependency|
      lines << "  depends_on #{ruby_string(dependency)} => :build"
    end
    config.fetch("dependencies").each do |dependency|
      lines << "  depends_on #{ruby_string(dependency)}"
    end
    lines << ""

    lines << "  def install"
    lines << "    system \"cargo\", \"install\", *std_cargo_args"
    lines << "  end"
    lines << ""

    lines << "  test do"
    lines << test_line(config.fetch("binary_name"), config.fetch("test_args"))
    lines << "  end"
    lines << "end"
    "#{lines.join("\n")}\n"
  end

  def test_line(binary_name, args)
    command = "    system \"\#{bin}/#{binary_name}\""
    args.each do |arg|
      command += ", #{ruby_string(arg)}"
    end
    command
  end

  def ruby_string(value)
    value.to_s.dump
  end
end

options = {
  config_path: "config/atctl-formula.json",
  tag: ENV["ATCTL_RELEASE_TAG"],
  sha256: ENV["ATCTL_SOURCE_SHA256"]
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/update-formula.rb --tag v0.1.0 [options]"

  parser.on("--tag TAG", "Release tag from uchimanajet7/atctl, for example v0.1.0") do |tag|
    options[:tag] = tag
  end

  parser.on("--config PATH", "Formula configuration JSON path") do |path|
    options[:config_path] = path
  end

  parser.on("--formula PATH", "Formula output path") do |path|
    options[:formula_path] = path
  end

  parser.on("--sha256 SHA256", "Use a precomputed source archive SHA-256 instead of fetching") do |sha256|
    options[:sha256] = sha256
  end
end.parse!

unless options[:tag]
  warn "missing required --tag TAG"
  exit 64
end

begin
  FormulaUpdater.new(options).run
rescue FormulaUpdateError => e
  warn e.message
  exit 1
end
