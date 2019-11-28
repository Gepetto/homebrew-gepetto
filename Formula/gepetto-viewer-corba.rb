class GepettoViewerCorba < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer-corba"
  url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.3.2/gepetto-viewer-corba-5.3.2.tar.gz"
  sha256 "272ace849a2d9eaa68788e9b46880ccf4f97cf033ac6cc20687ed453ceb72e94"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.3.2"
    sha256 "359495e7c1756aa80274994151980b30d444bc2ca1b85ae887174a10ffd007b0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "qt"
  depends_on "omniorb"
  depends_on "gepetto-viewer"
  depends_on "osgqt"
  depends_on "python@2" => :recommended if build.with? "python"

  def install
    if build.devel?
      system "git submodule cmake update --init"
    end
    
    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python2"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_bin}"
      args << "-DCMAKE_PREFIX_PATH=#{Formula["osgqt"].opt_prefix}/lib/pkgconfig"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
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

__END__
