class Tinymesa < Formula
  desc "Subset of mesa's libvulkan with vastly fewer dependencies"
  homepage "https://github.com/sirhcm/tinymesa"
  url "https://github.com/sirhcm/tinymesa/archive/refs/tags/tinymesa-32dc66c.tar.gz"
  version "25.2.4.1"
  sha256 "6a8d55283ee298fc4c1ac279583a85aa5d7d62b0119309695af2cb48c536a1ec"

  pour_bottle? do
    reason "This formula provides pre-built binaries and does not need to be bottled."
    satisfy { false }
  end

  depends_on arch: :arm64
  depends_on macos: [:sonoma, :sequoia]

  resource "sequoia_dylib" do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa-mesa-25.2.4-macos-15-arm64.dylib"
    sha256 "72c22f10ec521617efdf230a0b8e7e6dc67937d7c24211d41ec1ca6c4395be60"
  end

  resource "sonoma_dylib" do
    url "https://github.com/sirhcm/tinymesa/releases/download/tinymesa-32dc66c/libtinymesa-mesa-25.2.4-macos-14-arm64.dylib"
    sha256 "4db570bfce6f3fa797cecba7172e22bee489609b551e449b1b6e415ee8d4a090"
  end

  def install
    dylib_resource = if MacOS.version == :sequoia
      resource("sequoia_dylib")
    else
      resource("sonoma_dylib")
    end

    dylib_resource.stage do
      lib.install Dir["*.dylib"].first => "libtinymesa.dylib"
    end
  end
end
