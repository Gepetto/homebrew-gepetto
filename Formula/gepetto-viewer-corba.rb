class GepettoViewerCorba < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/humanoid-path-planner/gepetto-viewer-corba"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer-corba/releases/download/v2.0.0/gepetto-viewer-corba-2.0.0.tar.gz"
    sha256 "39ef619e57747656b76666863052607818d1fe0fd789baabf1d631671c19f412"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "qt@4"
  depends_on "omniorb"
  depends_on "gepetto-viewer"
  depends_on "osgqt"

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=#{Formula["qt@4"].opt_bin}"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["osgqt"].opt_prefix}/lib/pkgconfig"
    if build.devel?
      system "git submodule cmake update --init"
    end
    mkdir "build" do
      system "cmake", "..", *args, "-DBUILD_UNIT_TESTS=OFF"
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
