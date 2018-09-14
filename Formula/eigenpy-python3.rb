class EigenpyPython3 < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.5/eigenpy-1.4.5.tar.gz"
  sha256 "98d4838d3c3645140f389f810824c801f81b2c9fb39759bdad4979536461637d"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.5"
    
    sha256 "6e4a910e955a875d515680ecdc095b1bc8b73944fc08e1175af45b4f5472bb10" => :high_sierra
  end 

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python"

  def install
    
    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python3"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
