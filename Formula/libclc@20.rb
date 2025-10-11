class LibclcAT20 < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/libclc-20.1.8.src.tar.xz"
  sha256 "ecd83a52859742f71f4c332538f8bee54a6743374a233b5a85017de22d75c227"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(20(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/sirhcm/homebrew-tinymesa/releases/download/libclc@20-20.1.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "535867447130588c6bd0fdd65e995e7b4a131af2b21f23325f6db4ced5edf43e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505925a52b2414fb2e2993b0c804fc4b4ddad6c2a69ca8267049e5fcc7aaf5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00fb4a634816e37fafd6a577a9bb01a3605d5f26afa8bff30fabbcc91aaebc32"
  end

  depends_on "cmake" => :build
  depends_on "llvm@20" => [:build, :test]
  depends_on "spirv-llvm-translator@20" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator@20"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm@20"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
