class EigenpyPython3 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.13/eigenpy-1.6.13.tar.gz"
  sha256 "34807b837aae9d7388c546aa7d75a7a7c78242a15b44cad6e548d5e3d81a26a5"
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
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.13"
    sha256 "5a6b19914197c256709156cdd5a5ec3187052b36c208006157f6219ca186e90a" => :mojave
  end

  def install
    
    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
