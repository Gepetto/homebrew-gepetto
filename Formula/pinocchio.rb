class Pinocchio < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v1.2.9/pinocchio-1.2.9.tar.gz"
    sha256 "bb6a57ab6463cd041b3c887d3ec85c8503ee31713ef33b5657e4176698c05ca5"
    
    patch :DATA
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
      #system "make", "check"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

__END__
