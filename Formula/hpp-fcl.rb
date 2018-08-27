class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "http://www.openrobots.org/distfiles/hpp-fcl/hpp-fcl-0.5.1.tar.gz"
  sha256 "34faf1f779074554111929a581d98db5da4a5cb27bf0cbecb9a1a3fecf35d3f0"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v0.5.1"

    sha256 "eebf60b46d631fc9422cbb166c25deb9b19bd91a362f12a2daaeb0e6a7f64ccd" => :high_sierra
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "brewsci/homebrew-science/cddlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
