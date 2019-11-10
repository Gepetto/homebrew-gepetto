class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.1.2/hpp-fcl-1.1.2.tar.gz"
  sha256 "f1636895054cd2cf08efbde35b88505f6d973380d9605f408fb65f26f5228f89"
  patch :DATA

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  bottle do
    rebuild 1
    root_url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.1.2"
    sha256 "bcb6b2077fe8252347f6d404358dc34dae265fe8fa42c0cf4d724eeb69bd2315" => :mojave
  end 

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "eigen"
  depends_on "octomap"
  depends_on "boost"
  depends_on "brewsci/homebrew-science/cddlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
__END__
diff --git a/include/hpp/fcl/mesh_loader/assimp.h b/include/hpp/fcl/mesh_loader/assimp.h
index c769d67..fe751ce 100644
--- a/include/hpp/fcl/mesh_loader/assimp.h
+++ b/include/hpp/fcl/mesh_loader/assimp.h
@@ -3,7 +3,8 @@
  *
  *  Copyright (c) 2011-2014, Willow Garage, Inc.
  *  Copyright (c) 2014-2015, Open Source Robotics Foundation
- *  Copyright (c) 2016, CNRS - LAAS
+ *  Copyright (c) 2016-2019, CNRS - LAAS
+ *  Copyright (c) 2019, INRIA
  *  All rights reserved.
  *
  *  Redistribution and use in source and binary forms, with or without
@@ -37,6 +38,14 @@
 #ifndef HPP_FCL_MESH_LOADER_ASSIMP_H
 #define HPP_FCL_MESH_LOADER_ASSIMP_H
 
+// Assimp >= 5.0 is forcing the use of C++11 keywords. A fix has been submitted https://github.com/assimp/assimp/pull/2758.
+// The next lines fixes the bug for current version of hpp-fcl.
+#include <assimp/defs.h>
+#if __cplusplus < 201103L && defined(AI_NO_EXCEPT)
+  #undef AI_NO_EXCEPT
+  #define AI_NO_EXCEPT
+#endif
+
 #ifdef HPP_FCL_USE_ASSIMP_UNIFIED_HEADER_NAMES
   #include <assimp/DefaultLogger.hpp>
   #include <assimp/IOStream.hpp>
