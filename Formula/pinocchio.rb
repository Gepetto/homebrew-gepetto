class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v1.3.0/pinocchio-1.3.0.tar.gz"
    sha256 "2941318c1afa1235b26cbdeb5f133306475ac4cb419b57abc6a9d6c6f624869e"
    
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v1.3.0"

    rebuild 1
    sha256 "3f06b656f170474b0bf85a44e33a77694e898bcbace19c1ad26feb6f38b73b76" => :high_sierra
  end

  #head do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "master"
  #end

  #devel do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "devel"
  #end

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
    if build.devel?
      system "git submodule update --init"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_UNIT_TESTS=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
