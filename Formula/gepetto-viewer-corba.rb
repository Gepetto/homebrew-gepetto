class GepettoViewerCorba < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/humanoid-path-planner/gepetto-viewer"
  url "https://github.com/humanoid-path-planner/gepetto-viewer-corba"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer-corba/releases/download/v2.3.1/gepetto-viewer-corba-2.3.1.tar.gz"
    sha256 "214f5038aeba74a64b548f55c429401d08a43672682146b111c3ddfec8c7c4eb"
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/humanoid-path-planner/gepetto-viewer-corba/releases/download/v2.3.1"
    
    rebuild 1
    sha256 "e4cf462bb1a9f32506dafc4f472f2aae04211a875c5485d0abeb8bc5447ff8dc" => :high_sierra
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
