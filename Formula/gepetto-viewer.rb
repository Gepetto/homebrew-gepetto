class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer"
  head "https://github.com/Gepetto/gepetto-viewer.git", :branch => "devel"

  url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.8.0/gepetto-viewer-4.8.0.tar.gz"
  sha256 "5b27c3885987d5ab3b7d84b361a3ae75e4d13cf91461cc90919091ede9dbb061"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.8.0"
    rebuild 1
    sha256 "0d3840268b5edf42e3427b805999dfd1753e2fa85505a7acc3a22102c34cdc06" => :mojave
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
      system "git pull --tags"
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
