class Tinymesa < Formula
  desc "Subset of mesa's libvulkan with vastly fewer dependencies"
  homepage "https://github.com/sirhcm/tinymesa"
  url "https://github.com/sirhcm/tinymesa/archive/refs/tags/tinymesa-32dc66c.tar.gz"
  sha256 "6a8d55283ee298fc4c1ac279583a85aa5d7d62b0119309695af2cb48c536a1ec"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "llvm@20"

  on_sonoma do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa_cpu-mesa-25.2.4-macos-14-arm64.dylib"
    sha256 "619d8a96fc91c2c14442d54ed9d820953fe48680c76c560a4b5d8441189adc93"
  end

  on_sequoia do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa_cpu-mesa-25.2.4-macos-15-arm64.dylib"
    sha256 "d7a22b25eb6f7caa5d99d99eb2a4745e4b1ad93f88146bf8c2c927388da03822"
  end

  version "25.2.4"

  pour_bottle? do
    reason "This formula provides pre-built binaries and does not need to be bottled."
    satisfy { false }
  end

  def install
    lib.install Dir["*.dylib"].first => "libtinymesa_cpu.dylib"
  end
end

