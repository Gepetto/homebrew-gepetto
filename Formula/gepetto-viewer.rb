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

    sha256 "76e1d00d02339d26c2d8983bdde4f8926cc262d37e027d4c58e539b931513fb4" => :high_sierra
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
