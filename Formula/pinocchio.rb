class Pinocchio < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"

  stable do
    url "ftp://trac.laas.fr/pub/openrobots/pinocchio/pinocchio-1.2.0.tar.gz"
    sha256 "4c2383e6fdc2cb2b3cdc2ef8409fe76674ccd1b83f8e9b5f8fd5b550d11085c4"

    patch :p1, :DATA
  end

  head do
    url "https://github.com/jcarpent/pinocchio.git", :branch => "devel"
  end

  devel do
    url "ftp://trac.laas.fr/pub/openrobots/pinocchio/pinocchio-1.1.2.tar.gz"
    sha256 "732f0643093e3c04190cf0ccab2e112332419b8f5de06fdcd600be57efe2f87a"
    #url "https://github.com/stack-of-tasks/pinocchio/archive/devel.zip"
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
