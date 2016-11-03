class Urdfdom < Formula
  desc "The C++ parser for the Unified Robot Description Format (URDF)"
  homepage "https://github.com/ros/urdfdom"
  url "https://github.com/ros/urdfdom/archive/0.4.1.tar.gz"
  sha256 "6552e2b6de63b0ff7300909fa69d9bab18381b6184a05dc2fe744b2334a9fde5"

  head "https://github.com/ros/urdfdom.git", :branch => "master"

  depends_on "cmake" => :build
  depends_on "urdfdom-headers"
  depends_on "console-bridge"
  depends_on "boost"

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
