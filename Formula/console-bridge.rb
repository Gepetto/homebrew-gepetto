class ConsoleBridge < Formula
  desc "A ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages"
  homepage "https://github.com/ros/console_bridge"
  url "https://github.com/ros/console_bridge/archive/0.3.2.tar.gz"
  sha256 "fd12e48c672cb9c5d516d90429c4a7ad605859583fc23d98258c3fa7a12d89f4"

  head "https://github.com/ros/console_bridge.git", :branch => "master"

  depends_on "cmake" => :build

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
