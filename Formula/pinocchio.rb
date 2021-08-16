class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.3/pinocchio-2.6.3.tar.gz"
  sha256 "a287be23e927d99d3ef7e8c172c6ecb7e0dfcca43e68e27d3fb82aa650aac599"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.3"
    sha256 catalina: "e4bad8908a19510a5c00c2912c58e4695a56a1e59d3134aac2780ae47f2efce6"
  end

  option "without-python", "Build without Python support"
  option "without-hpp-fcl", "Build without HPP-FCL support"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python3" => :recommended if build.with? "python"
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "hpp-fcl"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "python@3.9" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"
    ENV.prepend_path "urdfdom_DIR", Formula["urdfdom"].opt_lib/"urdfdom/cmake"
    ENV.prepend_path "urdfdom_headers_DIR", Formula["urdfdom_headers"].opt_lib/"urdfdom_headers/cmake"
    ENV.prepend_path "console_bridge_DIR", Formula["console_bridge"].opt_lib/"console_bridge/cmake"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
      args << "-DCMAKE_CXX_STANDARD=11"
      args << "-DBUILD_WITH_COLLISION_SUPPORT=ON"
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
