class Osgqt < Formula
  desc "Use OpenSceneGraph inside your Qt applications"
  homepage "https://github.com/openscenegraph/osgQt"
  url "https://github.com/openscenegraph/osgQt/archive/3.5.7.tar.gz"
  sha256 "dcc4436590639168e6470fe9c5343c82bca738d3296ebee014f40f2dc029afa1"

  bottle do
    cellar :any
    root_url "https://github.com/jcarpent/osgQt/releases/download/3.5.7"
    cellar :any
    rebuild 2
    sha256 "79130364e8e970ac3d290073077cddeccf3997b09bbc4f835c907cec53227f80" => :mojave
  end

  option "with-docs", "Build the documentation with Doxygen"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gepetto/gepetto/open-scene-graph-with-colladadom"
  depends_on "qt"

  depends_on "doxygen" => :build if build.with? "docs"

  def install
    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + (build.with?("docs") ? "ON" : "OFF")

    args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>

      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{Formula["open-scene-graph-with-colladadom"].opt_lib}/", "-losg", "-L#{lib}", "-losgqt", "-o", "test"
    system "./test"
  end
end
