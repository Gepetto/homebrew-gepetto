class GepettoViewerCorbaPython3 < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/Gepetto/gepetto-viewer-corba"
  url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.3.2/gepetto-viewer-corba-5.3.2.tar.gz"
  sha256 "272ace849a2d9eaa68788e9b46880ccf4f97cf033ac6cc20687ed453ceb72e94"

  bottle do
    root_url "https://github.com/Gepetto/gepetto-viewer-corba/releases/download/v5.3.2"
    sha256 "350fd8ca88cd1bd5dc58231f308799b7b55f39cabd69022a0c7787c8ea63f6da" => :mojave
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
  depends_on "python3"

  def install
    if build.devel?
      system "git submodule cmake update --init"
    end
    
    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"

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

__END__
