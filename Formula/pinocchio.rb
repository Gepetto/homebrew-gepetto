class Pinocchio < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"

  stable do
    url "ftp://trac.laas.fr/pub/openrobots/pinocchio/pinocchio-1.2.1.tar.gz"
    sha256 "36611a5db186bf7b95de6279dba5bbb69cd5716fa43b799221de578a166b6177"
    
    patch :p0 do
      url "https://git.openrobots.org/projects/robotpkg-wip/repository/revisions/master/raw/pinocchio/patches/patch-aa"
      sha256 "c9d3ffc9772e71582462ce5113c8c340cb1a7beeb47d1ce388a657440b8f40f9"
    end

    patch :p0 do
      url "https://git.openrobots.org/projects/robotpkg-wip/repository/revisions/master/raw/pinocchio/patches/patch-ab"
      sha256 "252967f2aa09553595b54f8c2e5810c810fbc3083344681d1924d4d8c703f4f9"
    end
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
