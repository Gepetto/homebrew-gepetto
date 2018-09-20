class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/humanoid-path-planner/gepetto-viewer"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer/releases/download/v2.1.3/gepetto-viewer-2.1.3.tar.gz"
    sha256 "5958b0314761ab1a5e88712fe45680798cc69bfe40275c375192fdc53b5da9b5"
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/humanoid-path-planner/gepetto-viewer/releases/download/v2.1.3"

    rebuild 1
    sha256 "dbb32bdb0343fd71cbe95bb2e8514d97615a1e664a728d86f60ef97ca2f5a933" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "open-scene-graph"
  depends_on "urdfdom"
  depends_on :x11

  def install
    if build.devel?
      system "git submodule cmake update --init"
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
