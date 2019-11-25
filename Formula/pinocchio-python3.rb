class PinocchioPython3 < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"

  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.2.0/pinocchio-2.2.0.tar.gz"
  sha256 "0bbef3ef0e8c7aa623b1ca15f4acf6d360f07897e9c0c9b1c9fdaf0b44c9e8c5"

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.2.0"
    sha256 "ff2e32fc4c74b2d1af3cad184e846e1905737ed6a275aa8d0303834ed308626a" => :mojave
  end

  option "without-python", "Build without Python support"
  option "without-fcl", "Build without FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python3" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended
  depends_on "eigenpy-python3" => :recommended if build.with? "python"
  depends_on "python" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl-python3" => :recommended if build.with? "fcl"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end

    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
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
