class TinymesaCpu < Formula
  desc "Subset of mesa's libvulkan with vastly fewer dependencies (LLVMpipe)"
  homepage "https://github.com/sirhcm/tinymesa"
  url "https://github.com/sirhcm/tinymesa/archive/refs/tags/tinymesa-32dc66c.tar.gz"
  version "25.2.4"
  sha256 "6a8d55283ee298fc4c1ac279583a85aa5d7d62b0119309695af2cb48c536a1ec"

  bottle do
    root_url "https://github.com/sirhcm/homebrew-tinymesa/releases/download/tinymesa_cpu-25.2.4"
    sha256 cellar: :any, arm64_tahoe:   "9792924f6bac200d2949fe0f9b91258b0e88261898b762edc8f5838be55422e0"
    sha256 cellar: :any, arm64_sequoia: "496e4c22334dc5e04a138ef7d09f67fb70fd712da426fc4bd699e45f45267411"
    sha256 cellar: :any, arm64_sonoma:  "734267159f63f1645efc0a8e2c158befa6f2561264906ab19052fbafdd5139b6"
  end

  pour_bottle? do
    reason "This formula provides pre-built binaries and does not need to be bottled."
    satisfy { false }
  end

  depends_on arch: :arm64
  depends_on "llvm@20"
  depends_on macos: [:sonoma, :sequoia]

  resource "sequoia_dylib" do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa_cpu-mesa-25.2.4-macos-15-arm64.dylib"
    sha256 "d7a22b25eb6f7caa5d99d99eb2a4745e4b1ad93f88146bf8c2c927388da03822"
  end

  resource "sonoma_dylib" do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa_cpu-mesa-25.2.4-macos-14-arm64.dylib"
    sha256 "619d8a96fc91c2c14442d54ed9d820953fe48680c76c560a4b5d8441189adc93"
  end

  def install
    dylib_resource = if MacOS.version == :sequoia
      resource("sequoia_dylib")
    else
      resource("sonoma_dylib")
    end

    dylib_resource.stage do
      lib.install Dir["*.dylib"].first => "libtinymesa_cpu.dylib"
    end
  end
end
