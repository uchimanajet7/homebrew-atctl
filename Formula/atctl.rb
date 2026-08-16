class Atctl < Formula
  desc "CLI/TUI AT command controller for USB cellular modems"
  homepage "https://github.com/uchimanajet7/atctl"
  url "https://github.com/uchimanajet7/atctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "48694e075e09fe53a7183f97ea081d22b597e799534820984c1f09fb20a31597"
  license "MIT"

  bottle do
    root_url "https://github.com/uchimanajet7/homebrew-atctl/releases/download/atctl-0.2.0"
    sha256 cellar: :any, arm64_tahoe: "76a1b577e1381d733fdf0a639721749538964ed8cb72ecb01e949e0bf623a308"
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
