class Osgqt < Formula
  desc "Use OpenSceneGraph inside your Qt applications"
  homepage "https://github.com/openscenegraph/osgQt"
  url "https://github.com/openscenegraph/osgQt/archive/3.5.7.tar.gz"
  sha256 "dcc4436590639168e6470fe9c5343c82bca738d3296ebee014f40f2dc029afa1"

  bottle do
    cellar :any
    root_url "https://github.com/jcarpent/osgQt/releases/download/3.5.7"

    rebuild 1
    sha256 "c7e2e7b6954d0c0aef21bc17a722e5eaac7b511d7a6ac94d3118f6aab5e4df24" => :mojave
  end

  option "with-docs", "Build the documentation with Doxygen"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gepetto/gepetto/open-scene-graph-with-colladadom"
  depends_on "qt"

  depends_on "doxygen" => :build if build.with? "docs"

  def install
    ENV.cxx11 if build.cxx11?

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
