class Pinocchio < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"

  stable do
    url "http://www.openrobots.org/distfiles/pinocchio/pinocchio-1.2.3.tar.gz"
    sha256 "3d61ffd8fbd17baba66658fb9d7ccce48fe2b6af55546283d18af4ba31573fbd"
  end

  head do
    url "https://github.com/jcarpent/pinocchio.git", :branch => "master"
  end

  devel do
    url "https://github.com/jcarpent/pinocchio.git", :branch => "devel"
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
  depends_on "python" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "fcl"

  def install
    if build.devel?
      system "git submodule cmake update --init"
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
