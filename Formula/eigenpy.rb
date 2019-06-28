class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.3/eigenpy-1.5.3.tar.gz"
  sha256 "60ec5c5c160c631a098fd039e901dae9ecfd06f3066e595b8fb9f3b6d48338d1" 
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.5.3/eigenpy-1.5.3.mojave.bottle.tar.gz"
    sha256 "8f9eef2171b310b317bb545ce7d83ace44d28d09bdbfc1ee09406f8f93a1f856" => :mojave
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
