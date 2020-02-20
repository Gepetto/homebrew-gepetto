class HppFclAT2 < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.3.0/hpp-fcl-1.3.0.tar.gz"
  sha256 "ffdd5487ef93ba0ac190807d1ef71528e380803a46a69204916944f5df82b218"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  option "without-python", "Build without Python support"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.3.0"
    sha256 "d8074e73a962b108c23e7696f81e2c7d88bf7d7bbe5ddbd82c61003c85df61fd" => :mojave
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
  depends_on "eigenpy@2" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end 

    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python@2"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    mkdir "build" do
      args = *std_cmake_args
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
