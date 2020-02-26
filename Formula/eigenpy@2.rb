class EigenpyAT2 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.1.0/eigenpy-2.1.0.tar.gz"
  sha256 "1803e0a535d42c8c8393b5fa5a208cec1e3c7ec8b94d69007e84413efa73fa06" 
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.1.0"
    sha256 "5bb6fac304353e4dc7ee2a04fe3e7c903660e66eac2237bff03f78a48a52d343" => :mojave
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
    py_prefix = Formula["python@2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    ENV.prepend_path "PYTHONPATH", Formula["numpy@1.16"].opt_lib/"python#{pyver}/site-packages"
    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
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
