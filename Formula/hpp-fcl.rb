class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.6.0/hpp-fcl-1.6.0.tar.gz"
  sha256 "47dc6007557366880cb39ae658dd7312db357e51121037e0fadb4773ea7c56e5"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "devel"

  option "without-python", "Build without Python support"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.6.0"
    rebuild 1
    sha256 "bb2723123d8cfee07264b021884a0f5e47093282adc237c3d42cf3cc96307764" => :catalina
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
  depends_on "python@3.9" => :recommended if build.with? "python"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end 

    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"

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
