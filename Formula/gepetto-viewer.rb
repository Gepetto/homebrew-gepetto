class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer"
  head "https://github.com/Gepetto/gepetto-viewer.git", :branch => "devel"

  url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.9.0/gepetto-viewer-4.9.0.tar.gz"
  sha256 "96ea07f6f99078d3a32fc29daea47ce5ad39acb5e5f0c4f65e33850ed0d4d27b"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.9.0"
    sha256 "1e3f74c993583fb4355e7599f96f3e90a1518e7bfd02dae61bd1eb97a2a9347b" => :mojave
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
    if build.head?
      system "git fetch --unshallow --tags"
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
