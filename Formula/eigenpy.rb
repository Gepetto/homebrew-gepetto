class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.0/eigenpy-1.6.0.tar.gz"
  sha256 "054e6efb3e9fbf1eb71eccc45e27fc7a42bf823271e50e82d91570d85f0ce8bb"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    sha256 "9fffd4df1e737dbe47db2c737d7725a0287ccc02ee5f9a81424f2d356b41520b" => :mojave
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.0/eigenpy-1.6.0.mojave.bottle.tar.gz"
  end

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy"
  depends_on "python@2"

  def install
    mkdir "build" do
      args = *std_cmake_args
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
