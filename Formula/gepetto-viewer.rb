class GepettoViewer < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/humanoid-path-planner/gepetto-viewer"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer/releases/download/v4.3.0/gepetto-viewer-4.3.0.tar.gz"
    sha256 "98f25dede2a355b8d1e63ab8b6eafa28e41da44374570088eb09747b7508790d"
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
