class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.2.1/hpp-fcl-1.2.1.tar.gz"
  sha256 "5c540cf2e695116fc9541733067ac2a0e01a4fe643071cd6cbd8434e52367e48"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  option "without-python", "Build without Python support"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.2.1"
    sha256 "8a2340cf7aab308e942f12d3a729180312c76961e77117cf7ed1bc1436bfd586" => :mojave
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "octomap"
  depends_on "boost"
  depends_on "brewsci/homebrew-science/cddlib"
  depends_on "boost-python" => :recommended if build.with? "python"
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"

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
      args << "-DBUILD_PYTHON_INTERFACE=ON"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
