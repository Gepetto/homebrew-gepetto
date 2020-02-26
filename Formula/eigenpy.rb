class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.1.0/eigenpy-2.1.0.tar.gz"
  sha256 "1803e0a535d42c8c8393b5fa5a208cec1e3c7ec8b94d69007e84413efa73fa06" 
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.1.0"
    sha256 "0728615f4f3160b054af6aa7bbcc119dc9e4285c29c61a56ca85affdea29deb3" => :mojave
  end

  def install
    
    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
      args << "-DBUILD_UNIT_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
