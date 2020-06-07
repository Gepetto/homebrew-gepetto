class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.4.5/hpp-fcl-1.4.5.tar.gz"
  sha256 "d7dbd7ede3613bf3e499466a114d1f74ef6ed95d3901b2d59ea14aa17f303416"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "devel"

  option "without-python", "Build without Python support"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.4.5"
    sha256 "73a193f9c0da8bfb9d59181fd8d848ad6a1955f8446fa3796e734312e7e5ea66" => :mojave
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "octomap"
  depends_on "boost"
  depends_on "cddlib"
  depends_on "boost-python3" => :recommended if build.with? "python"
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@3.8" => :recommended if build.with? "python"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end 

    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"

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
