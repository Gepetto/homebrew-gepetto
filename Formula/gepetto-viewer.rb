class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer"

  url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.8.0/gepetto-viewer-4.8.0.tar.gz"
  sha256 "5b27c3885987d5ab3b7d84b361a3ae75e4d13cf91461cc90919091ede9dbb061"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.8.0"
    sha256 "1bfe1327dab54282fe0647b2ea4c068110204f44b26fec5c3d17f4637c0ad51e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "gepetto/gepetto/open-scene-graph-with-colladadom"
  depends_on "urdfdom"
  depends_on "osgqt"
  depends_on :x11

  def install
    if build.devel?
      system "git submodule cmake update --init"
    end
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_CXX_FLAGS=-std=gnu++11"
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
