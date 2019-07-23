class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.5/pinocchio-2.1.5.tar.gz"
    sha256 "773c0cb037c1fbddda4668dd357d65cd6914566462b4faf5f37295964e35c996"
  end

  patch do
    url "https://github.com/jcarpent/pinocchio/commit/18d51c3ce0a081be509d0bead383004360aa44fd.diff\?full_index\=1"
    sha256 "e594851aba1b5c21a4e04b23d6c0b56790177daeddf5b3f24b924a468b8df313"
  end

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.5"
    sha256 "f14dea646c1786f897a13252564f497c0af623aee9e2027e4d627d409806faef" => :mojave
  end

  option "without-python", "Build without Python support"
  option "without-fcl", "Build without FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "fcl"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end

    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
      args << "-DBUILD_UNIT_TESTS=OFF"
      args << "-DBUILD_WITH_COLLISION_SUPPORT=ON"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
