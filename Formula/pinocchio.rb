class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.4.5/pinocchio-2.4.5.tar.gz"
  sha256 "559fe0ffc969b4dca964525bbba69362dbec821dc216c6f9f2f71b33bcbc9fda"

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.4.5"
    sha256 "93b7a18e17324d862fbd00432a56b01999ac0a2ac1805c9fa1f0bd6a34d32207" => :mojave
  end

  option "without-python", "Build without Python support"
  option "without-hpp-fcl", "Build without HPP-FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python3" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@3.8" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "hpp-fcl"

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
