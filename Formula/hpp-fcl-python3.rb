class HppFclPython3 < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.2.2/hpp-fcl-1.2.2.tar.gz"
  sha256 "2b60468f137e0045c60d8561836f6c714838cf891369ec96d5ed945ad824b6f2"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  option "without-python", "Build without Python support"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.2.2"
    sha256 "5f2aea8304e967e9fdb1fc4c967cddd676fd286d6e576b1c79a64a9ff64243aa" => :mojave
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "octomap"
  depends_on "boost"
  depends_on "brewsci/homebrew-science/cddlib"
  depends_on "boost-python3" => :recommended if build.with? "python"
  depends_on "eigenpy-python3" => :recommended if build.with? "python"
  depends_on "python" => :recommended if build.with? "python"

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
      args << "-DBUILD_PYTHON_INTERFACE=ON"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
