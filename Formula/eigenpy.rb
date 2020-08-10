class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.4.3/eigenpy-2.4.3.tar.gz"
  sha256 "cce237d876e849af71ed2b08e471271563f56620223e1b8409076df3ba09fca5"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "numpy" => :build
  depends_on "eigen"
  depends_on "boost-python3"
  depends_on "python@3.8"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.4.3"
    sha256 "75f1faf144e7ad66749b4d601e81e5ccf4d0f766ec1acdf82c44ebe4266d646c" => :mojave
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
