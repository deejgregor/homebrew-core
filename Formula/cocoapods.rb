class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.0.tar.gz"
  sha256 "4f494e7651cdf1a7afae6117fb1ed33c919471d7bc3b7575a68d5c316faf567c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6183dd8e0cf8e8c996465d9ef4faa630d670ccda38a9e105f9edc5e06aa9f4b5"
    sha256                               big_sur:       "700b2ec47e11d0b084a1305193ed4bc7cd09ce047939d778f2a6c0f3651bcd03"
    sha256                               catalina:      "1cbfa6ef8dc560f0758715638ad719884e222e646989ad39bd3d9a04364d1de2"
    sha256 cellar: :any,                 mojave:        "4256c1df22de7e9ace48f888232e8cf469bff6e7ae2a0c9adb48fc65e71f1b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb6497e79b5fbe5e85b601498173a231414b796da50a050a29724e3c3226bd7"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" if Hardware::CPU.arm?

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
