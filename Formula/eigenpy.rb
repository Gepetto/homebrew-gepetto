class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.5/eigenpy-1.4.5.tar.gz"
  sha256 "98d4838d3c3645140f389f810824c801f81b2c9fb39759bdad4979536461637d"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.5"

    sha256 "f4adf4c40983cd2bcc360da25af6871fbc3d91015cc4164b1b5a31e9dc16c3a0" => :high_sierra
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
