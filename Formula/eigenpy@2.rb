class EigenpyAT2 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.3.1/eigenpy-2.3.1.tar.gz"
  sha256 "d8f3c642950751d7220899de84efd5009ab928838284440527f1bd09ed1697e4"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.3.1"
    sha256 "9e7db5a4c8d133ad24cdda67ac5e19d94932fcdd9795cd308097259f04bffc40" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy@1.16" => : build
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
