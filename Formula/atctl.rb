class Atctl < Formula
  desc "CLI/TUI AT command controller for USB cellular modems"
  homepage "https://github.com/uchimanajet7/atctl"
  url "https://github.com/uchimanajet7/atctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "1e1272e90fee30fd9808a1e5da364a5add59b2478937bc73c4adf666b788f3ce"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on "libusb"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/atctl", "--version"
  end
end
