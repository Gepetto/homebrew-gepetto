class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.0.1/hpp-fcl-1.0.1.tar.gz"
  sha256 "05844d9c67d4bad75e25ab95c2057036e3bbded9be82f0d59d95981ca393ab08"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.0.1"
    rebuild 1
    sha256 "1735294a013ffb4bd6e57407b4cd96c4158c5cedac6e3e0d3545fdae256b39d1" => :mojave
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "octomap"
  depends_on "boost"
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
