class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://stack-of-tasks.github.io/pinocchio"
  #url "http://www.openrobots.org/distfiles/eigenpy/eigenpy-1.4.0b.tar.gz"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.0/eigenpy-1.4.0.tar.gz"
  sha256 "93ead77a225499a55dd8e113234d2191a223ab5bc72270e0aba5bdecd4c09c9b"
  head "https://github.com/jcarpent/eigenpy.git", :branch => "devel"

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy"
  depends_on :python


  def install
    #ENV.deparallelize
    #ENV.m64
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      #args << "-DCMAKE_CXX_FLAGS_RELEASE=-DEIGEN_MALLOC_ALREADY_ALIGNED"
      args << "-DCMAKE_BUILD_TYPE=Release"
      #args << "-DCMAKE_FIND_FRAMEWORK=LAST"
      #args << "-DCMAKE_VERBOSE_MAKEFILE=ON"
      #ENV.delete('CFLAGS')
      #ENV.delete('CXXFLAGS')
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
__END__
