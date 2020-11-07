class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.5.2/pinocchio-2.5.2.tar.gz"
  sha256 "0eeb8e7d749e1b7c22fe6eb8515ec66670f5875c15138fc574a30b6a1b3f6170"

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.5.2"
    sha256 "d0ff16884c95e03961eb779af43002f5191d6c866959a1af04ab492af0acfd16" => :mojave
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
  depends_on "python@3.9" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "hpp-fcl"

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
