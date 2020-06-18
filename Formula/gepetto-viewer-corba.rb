class GepettoViewerCorba < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer-corba"
  url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.4.0/gepetto-viewer-corba-5.4.0.tar.gz"
  sha256 "9948a276a0733939b86f14afecf96802d95f618a5a4daa59d0b2ab9b4127c3a1"
  head "https://github.com/Gepetto/gepetto-viewer-corba.git", :branch => "devel"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.4.0"
    sha256 "38f955f38cd39d3d576357492a973c7bbcb7f4dd14ba9eb22f14aa1b1d6f2cda" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "qt"
  depends_on "omniorb"
  depends_on "omniorbpy"
  depends_on "gepetto-viewer"
  depends_on "osgqt"
  depends_on "python@3.8"

  def install
    if build.head?
      system "git fetch --unshallow --tags"
    end
    
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_bin}"
      args << "-DCMAKE_PREFIX_PATH=#{Formula["osgqt"].opt_prefix}/lib/pkgconfig"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
      args << "-DBUILD_UNIT_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
