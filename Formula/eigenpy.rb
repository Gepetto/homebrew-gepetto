class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.4.0/eigenpy-2.4.0.tar.gz"
  sha256 "dc554a0b45eb4ffe3b1c3d8aa31e7d5db82b0151402c706f3eb7fea4a72bf24d"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "numpy" => :build
  depends_on "eigen"
  depends_on "boost-python3"
  depends_on "python@3.8"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.4.0"
    sha256 "f64d185f56982959d84a851f04b1e8eaffdf9d49f2128c84f0ca4bb806f2d26f" => :mojave
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
