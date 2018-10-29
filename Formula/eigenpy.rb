class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.0/eigenpy-1.5.0.tar.gz"
  sha256 "4385bf1b8f8624a584022817b41e6b3e300a5e942f974e3c9d41643fafd0bf74"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.0"
    sha256 "f56543ea3f9e74970b69ba801f9f38b54e77c73e6dc3d84804583b542a9de681" => :mojave
  end 

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy"
  depends_on "python@2"

  def install
    mkdir "build" do
      args = *std_cmake_args
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
