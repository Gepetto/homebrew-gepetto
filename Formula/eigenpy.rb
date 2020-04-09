class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.3.1/eigenpy-2.3.1.tar.gz"
  sha256 "d8f3c642950751d7220899de84efd5009ab928838284440527f1bd09ed1697e4"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "numpy" => :build
  depends_on "eigen"
  depends_on "boost-python3"
  depends_on "python@3.8"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.3.1"
    sha256 "3a603abe91147cd8e54dc21956db96653486a0e79597489c81304cf614ac703c" => :mojave
  end

  def install
    
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"
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
