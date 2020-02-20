class EigenpyAT2 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.0.3/eigenpy-2.0.3.tar.gz"
  sha256 "cc9a060977c10b0f0b1b34deed1ffcceee63459d30884c5bbd4b48c4c19f5ab7"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.0.3"
    sha256 "ac4af5f3160495ef37d6cc87c3d1fb37316a5f28a722eaec85125244db2d8383" => :mojave
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
