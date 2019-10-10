class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.0/eigenpy-1.6.0.tar.gz"
  sha256 "054e6efb3e9fbf1eb71eccc45e27fc7a42bf823271e50e82d91570d85f0ce8bb"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    rebuild 1
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.0/eigenpy-1.6.0.mojave.bottle.1.tar.gz"
    sha256 "8e541a006c1f3099573a51854f82d39b2942b2747c1bb228b679870d5c478d87" => :mojave
  end

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy@1.16"
  depends_on "python@2"

  def install
    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
