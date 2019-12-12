class EigenpyPython3 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.12/eigenpy-1.6.12.tar.gz"
  sha256 "1f39382acacc8876fa164b3f319767811a709f0a27a7be5e1c79324f59e39cc1"
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
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.12"
    sha256 "8a57d59878a71dee1b9f22e23586b7cbd965a1c92ac2485fdd996e91e551a149" => :mojave
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
