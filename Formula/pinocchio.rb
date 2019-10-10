class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.9/pinocchio-2.1.9.tar.gz"
    sha256 "c694a9cd0669258a9655b4b45c283547eab40a7a86c8717b163c811fc351c12d"
  end

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.9"
    sha256 "99b54409495b31e41cfca6e65e3cbd66b3e61113bb38242c357c49f299b49ab7" => :mojave
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
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
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
