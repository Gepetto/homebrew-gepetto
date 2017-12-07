class GepettoViewer < Formula
  desc "An efficient library for Rigid Body Dynamics"
  homepage "https://stack-of-tasks.github.io/pinocchio"

  stable do
    url "https://github.com/humanoid-path-planner/gepetto-viewer/releases/download/v2.0.0/gepetto-viewer-2.0.0.tar.gz"
    sha256 "23a39b64b98f043a587b806841e552ce2c201d0770fcec6884d4ce8fa41f83d1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "open-scene-graph"
  depends_on "urdfdom"
  depends_on :x11

  patch :DATA

  def install
    if build.devel?
      system "git submodule cmake update --init"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_UNIT_TESTS=OFF"
      system "make"
      #system "make", "check"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

__END__

diff --git a/src/window-manager.cpp b/src/window-manager.cpp
index 8eb72f9..20aef92 100644
--- a/src/window-manager.cpp
+++ b/src/window-manager.cpp
@@ -539,7 +539,7 @@ namespace graphics {
 
   void WindowManager::getCameraTransform(osg::Vec3d& pos,osg::Quat& rot){
     osg::Matrixd matrix = manipulator_ptr->getMatrix();
-    matrix.get(rot);
+    rot = matrix.getRotate();
     pos = matrix.getTrans();
   }:
