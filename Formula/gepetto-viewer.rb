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

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8fd8206..9e8d773 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -73,6 +73,11 @@ INCLUDE_DIRECTORIES(${X11_INCLUDE_DIR})
 FIND_PACKAGE(OpenGL REQUIRED)
 
 ADD_REQUIRED_DEPENDENCY("openscenegraph >= 3.2")
+IF(${OPENSCENEGRAPH_VERSION} VERSION_GREATER "3.5.5")
+  ADD_DEFINITIONS(-DOSG_3_5_6_OR_LATER)
+  PKG_CONFIG_APPEND_CFLAGS("-DOSG_3_5_6_OR_LATER")
+ENDIF()
+
 ADD_REQUIRED_DEPENDENCY("urdfdom")
 
 SEARCH_FOR_BOOST()
diff --git a/src/leaf-node-box.cpp b/src/leaf-node-box.cpp
index d49d2f1..fc0651a 100644
--- a/src/leaf-node-box.cpp
+++ b/src/leaf-node-box.cpp
@@ -118,6 +118,9 @@ namespace graphics {
         box_ptr_->setHalfLengths(half_axis);
         shape_drawable_ptr_->dirtyDisplayList();
         shape_drawable_ptr_->dirtyBound();
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeBox::setColor (const osgVector4 &color)
diff --git a/src/leaf-node-capsule.cpp b/src/leaf-node-capsule.cpp
index 8061fbd..6971a51 100644
--- a/src/leaf-node-capsule.cpp
+++ b/src/leaf-node-capsule.cpp
@@ -125,11 +125,17 @@ namespace graphics {
     void LeafNodeCapsule::setRadius (const float& radius)
     {
         capsule_ptr_->setRadius(radius);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeCapsule::setHeight (const float& height)
     {
         capsule_ptr_->setHeight(height);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
 
     void LeafNodeCapsule::resize(float height){
@@ -140,6 +146,9 @@ namespace graphics {
         shape_drawable_ptr_ = new ::osg::ShapeDrawable(capsule_ptr_);
         shape_drawable_ptr_->setColor(color);
         geode_ptr_->addDrawable(shape_drawable_ptr_);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
         }
     }
     
diff --git a/src/leaf-node-cone.cpp b/src/leaf-node-cone.cpp
index 7872370..07d9fff 100644
--- a/src/leaf-node-cone.cpp
+++ b/src/leaf-node-cone.cpp
@@ -113,11 +113,17 @@ namespace graphics {
     void LeafNodeCone::setRadius (const float& radius)
     {
         cone_ptr_->setRadius(radius);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeCone::setHeight (const float& height)
     {  
         cone_ptr_->setHeight(height);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeCone::setColor (const osgVector4& color)
diff --git a/src/leaf-node-cylinder.cpp b/src/leaf-node-cylinder.cpp
index c7f0ecb..a7d5fc2 100644
--- a/src/leaf-node-cylinder.cpp
+++ b/src/leaf-node-cylinder.cpp
@@ -122,6 +122,9 @@ namespace graphics {
     void LeafNodeCylinder::setRadius (const float& radius)
     {        
         cylinder_ptr_->setRadius(radius);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeCylinder::setHeight (const float& height)
@@ -132,6 +135,9 @@ namespace graphics {
     void LeafNodeCylinder::setColor (const osgVector4& color)
     {
         shape_drawable_ptr_->setColor(color);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
 
     void LeafNodeCylinder::setTexture(const std::string& image_path)
diff --git a/src/leaf-node-sphere.cpp b/src/leaf-node-sphere.cpp
index 347a5c8..19309c1 100644
--- a/src/leaf-node-sphere.cpp
+++ b/src/leaf-node-sphere.cpp
@@ -116,6 +116,9 @@ namespace graphics {
     void LeafNodeSphere::setRadius (const float& radius)
     {
         sphere_ptr_->setRadius(radius);
+#ifdef OSG_3_5_6_OR_LATER
+        shape_drawable_ptr_->build();
+#endif
     }
     
     void LeafNodeSphere::setColor (const osgVector4& color)
diff --git a/tests/test.cpp b/tests/test.cpp
index 289cde5..6713fcb 100644
--- a/tests/test.cpp
+++ b/tests/test.cpp
@@ -26,7 +26,7 @@
   {
     using namespace graphics;
 
-    LeafNodeBoxPtr_t box = LeafNodeBox::create("box1", osgVector3(1.,1.,1.));
+    LeafNodeBoxPtr_t box = LeafNodeBox::create("box1", osgVector3(0.1,0.2,0.3));
     /*LeafNodeCapsulePtr_t capsule = LeafNodeCapsule::create("capsule1", 1,1);
     LeafNodeConePtr_t cone = LeafNodeCone::create("cone", 1,1);
     LeafNodeCylinderPtr_t cylindre = LeafNodeCylinder::create("cylindre", 1,1);
