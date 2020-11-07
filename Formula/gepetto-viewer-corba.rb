class GepettoViewerCorba < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer-corba"
  url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.5.1/gepetto-viewer-corba-5.5.1.tar.gz"
  sha256 "20c459c7181822b996a28ad188e0e199283c4f6e802e5df1b2075d6b10099326"
  head "https://github.com/Gepetto/gepetto-viewer-corba.git", :branch => "devel"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.5.1"
    sha256 "89abab66541f5b866b08d63818610fe074aa6219b8680671666d4730f1fbb05b" => :mojave
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
  depends_on "python@3.9"


  def install
    if build.head?
      system "git fetch --unshallow --tags"
    end
    
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"

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
