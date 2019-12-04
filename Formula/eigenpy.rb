class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.8/eigenpy-1.6.8.tar.gz"
  sha256 "fb1976ff27b7e62cb38db2394c49c4d534a35892c4668c93ad5adc3942166108"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    rebuild 1
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.6.8"
    sha256 "19e14ab376b10637312fe7485a66dcec2e20974ce3cc12717be47794fbb75938" => :mojave
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
    ENV.prepend_path "PYTHONPATH", Formula["numpy@1.16"].opt_lib/"python#{pyver}/site-packages"
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
