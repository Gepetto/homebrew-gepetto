class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.1.2/hpp-fcl-1.1.2.tar.gz"
  sha256 "f1636895054cd2cf08efbde35b88505f6d973380d9605f408fb65f26f5228f89"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  bottle do
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.1.2"
    sha256 "78ff435de98ec2769045a7397f873210ab495d1fa1e26b65ee9fdefb1859eee8" => :mojave
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
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
