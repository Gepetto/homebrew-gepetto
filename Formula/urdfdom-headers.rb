class UrdfdomHeaders < Formula
  desc "The headers of the C++ parser for the Unified Robot Description Format (URDF)"
  homepage "https://github.com/ros/urdfdom_headers"
  url "https://github.com/ros/urdfdom_headers/archive/0.4.1.tar.gz"
  sha256 "e210f9234af47bfc9fa4bb17d004fb3eac4513dcdfe639fb7b1c2db6408c8cd8"

  head "https://github.com/ros/urdfdom_headers.git", :branch => "master"

  depends_on "cmake" => :build
  depends_on "console-bridge"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
