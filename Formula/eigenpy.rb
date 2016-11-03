class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "ftp://trac.laas.fr/pub/openrobots/eigenpy/eigenpy-1.3.1.tar.gz"
  sha256 "69e3a403322f99ed029532c350e0613f51630b0439724dcb103f68d55f8873c7"

  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "master"

  patch :p1, :DATA

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy"
  depends_on "python"


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
__END__
