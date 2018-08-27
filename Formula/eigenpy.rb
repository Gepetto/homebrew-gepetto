class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.4/eigenpy-1.4.4.tar.gz"
  sha256 "dd9280d1263e2e110bbb1ddc0eb9dd515b3c5d15fadc104b3d1b32904fe2e4e7"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.4"

    sha256 "5444bb2b3c778d2d60110fd00092eae53d3ecb0155db6b4e0adeaa9b3afb68af" => :high_sierra
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
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
