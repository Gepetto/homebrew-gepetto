class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.7/eigenpy-1.5.7.tar.gz"
  sha256 "a19a086c4df7ebc05de903ebbf6cb9d33d91c468f3938a53e8007e9ce013ac7e"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.7/eigenpy-1.5.7.mojave.bottle.tar.gz"
    sha256 "b5817c49030eb48f92f46187e8f7017fe7a40fe21435c991aa176239684ec5d0" => :mojave
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
