class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.0/eigenpy-2.6.0.tar.gz"
  sha256 "65e1c3f3d0f408cd49d512b34ef392fc88845f227289ac72bc55f6a5e3a30299"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "numpy"
  depends_on "eigen"
  depends_on "boost" => :build
  depends_on "boost-python3"
  depends_on "python@3.9"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.0"
    sha256 "a79842e3cdae1cc469bfad915f24e81c08eca5fc46a8abaff12d21f2d67a9939" => :catalina
  end

  def install
    
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python#{pyver}/site-packages"
    
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
