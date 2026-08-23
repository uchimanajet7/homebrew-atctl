class Atctl < Formula
  desc "CLI/TUI AT command controller for USB cellular modems"
  homepage "https://github.com/uchimanajet7/atctl"
  url "https://github.com/uchimanajet7/atctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "1e1272e90fee30fd9808a1e5da364a5add59b2478937bc73c4adf666b788f3ce"
  license "MIT"

  bottle do
    root_url "https://github.com/uchimanajet7/homebrew-atctl/releases/download/atctl-0.2.1"
    sha256 cellar: :any, arm64_tahoe: "219ac807774612656f7c9b356f2f3fb68baf8acfac2ba0fa4417d19ff60efc4f"
  end

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
