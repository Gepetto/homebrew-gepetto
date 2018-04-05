class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.1/eigenpy-1.4.1.tar.gz"
  sha256 "9a616f4c318e7faa389e96d6e0acc0aff8941c7ef914d803b68e4183e0291c85"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

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
__END__
