class GepettoViewerCorbaPython3 < Formula
  desc "Graphical Interface for Pinocchio and HPP"
  homepage "https://github.com/humanoid-path-planner/gepetto-viewer-corba"
  url "https://github.com/humanoid-path-planner/gepetto-viewer-corba"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer-corba/releases/download/v5.1.3/gepetto-viewer-corba-5.1.3.tar.gz"
    sha256 "ff774b69b0d28021db5f1a6285bbab2f0ef2cd09babc0847e3e7a4b977370e9b"
  end

  bottle do
    root_url "https://github.com/humanoid-path-planner/gepetto-viewer-corba/releases/download/v5.1.3"
    sha256 "2ed451345a74c416bc32605448747e6b9f7868b69d443d10afcd63fa3ccb5bee" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "qt"
  depends_on "omniorb"
  depends_on "gepetto-viewer"
  depends_on "osgqt"
  depends_on "python3" => :recommended if build.with? "python"

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
