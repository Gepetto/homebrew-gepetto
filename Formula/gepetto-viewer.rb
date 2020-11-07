class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer"
  head "https://github.com/Gepetto/gepetto-viewer.git", :branch => "devel"

  url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.11.0/gepetto-viewer-4.11.0.tar.gz"
  sha256 "461d55c050ee3ef1c4476e2821053f0ec0362b2476e39bf8d8d9d734b196cd8e" 

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.11.0"
    sha256 "01e36b951ccabf959ec1b21babc3f0614d40927e68ba51961298f3b3d5c86b42" => :mojave
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
