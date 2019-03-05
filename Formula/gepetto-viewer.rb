class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/humanoid-path-planner/gepetto-viewer"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer/releases/download/v4.4.1/gepetto-viewer-4.4.1.tar.gz"
    sha256 "038889e00cc781503714b7eb823977299f8b189edf82b5a663c7307315d2800f"
  end

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer/releases/download/v4.4.1"
    sha256 "926d3ab851b80d2e4ccf6cc178d23870acf8f54872805d396256621ac5ce9206" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "gepetto/gepetto/open-scene-graph-with-colladadom"
  depends_on "urdfdom"
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
