class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.6/eigenpy-2.6.6.tar.gz"
  sha256 "d5ece10d1c255de746352b5d225b7216d258fb3f0df0d0fb39e0c86d8b6a0dfa"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.6"
    sha256 catalina: "e185d761b48780d287296cf514b0a9ad57799a5a60f7e235f002c406225bea94"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.9"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python#{pyver}/site-packages"
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

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
