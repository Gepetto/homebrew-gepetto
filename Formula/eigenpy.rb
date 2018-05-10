class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v1.4.2/eigenpy-1.4.2.tar.gz"
  sha256 "7423facf947edfa0f29ee3b31c766e37cb4ccd39272895846ac7c750c939d80e"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on :xcode => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "boost-python"
  depends_on "numpy"
  depends_on "python@2"

  patch :DATA

  def install
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
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
Submodule cmake 212cba4..bc74804:
diff --git a/cmake/.docs/conf.py b/cmake/.docs/conf.py
index ca76480..fedf487 100644
--- a/cmake/.docs/conf.py
+++ b/cmake/.docs/conf.py
@@ -15,7 +15,7 @@
 import sys
 import os
 
-from sphinx.util.compat import Directive
+from docutils.parsers.rst import Directive
 from docutils import nodes
 from sphinx.util.nodes import set_source_info
 
diff --git a/cmake/boost.cmake b/cmake/boost.cmake
index 95f28eb..538b995 100644
--- a/cmake/boost.cmake
+++ b/cmake/boost.cmake
@@ -1,4 +1,4 @@
-# Copyright (C) 2008-2016 LAAS-CNRS, JRL AIST-CNRS.
+# Copyright (C) 2008-2018 LAAS-CNRS, JRL AIST-CNRS.
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -16,8 +16,8 @@
 #.rst:
 # .. variable:: BOOST_COMPONENTS
 #
-#  Controls the components to be detected.  If
-#  this variable is not defined, it defaults to the following component
+#  Controls the components to be detected.  
+#  If this variable is not defined, it defaults to the following component
 #  list:
 #
 #  - Filesystem
@@ -33,6 +33,11 @@
 #
 #  The components to be detected is controlled by :variable:`BOOST_COMPONENTS`.
 #
+#  A special treatment must be done for the boost-python component. 
+#  For boost >= 1.67.0, FindPython macro should be called first in order
+#  to automatically detect the right boost-python component version according
+#  to the Python version (2.7 or 3.x).
+#
 MACRO(SEARCH_FOR_BOOST)
   SET(Boost_USE_STATIC_LIBS OFF)
   SET(Boost_USE_MULTITHREAD ON)
@@ -41,11 +46,52 @@ MACRO(SEARCH_FOR_BOOST)
     SET(BOOST_REQUIRED 1.40)
   ENDIF(NOT BOOST_REQUIRED)
 
+  # First try to find Boost to get the version
+  FIND_PACKAGE(Boost ${BOOST_REQUIRED})
+
   IF(NOT DEFINED BOOST_COMPONENTS)
     SET(BOOST_COMPONENTS
       filesystem system thread program_options unit_test_framework)
   ENDIF(NOT DEFINED BOOST_COMPONENTS)
 
+  # Check if python is in the list and adjust the version according to the current Python version.
+  # This is made mandatory if for Boost version greater than 1.67.0
+  IF(Boost_VERSION VERSION_GREATER 106699)
+    LIST(FIND BOOST_COMPONENTS python PYTHON_IN_BOOST_COMPONENTS)
+    SET(BOOST_COMPONENTS_ ${BOOST_COMPONENTS})
+    IF(${PYTHON_IN_BOOST_COMPONENTS} GREATER -1)
+      # Check if Python has been found
+      IF(NOT PYTHONLIBS_FOUND)
+        MESSAGE(FATAL_ERROR "PYTHON has not been found. You should first call FindPython before calling SEARCH_FOR_BOOST macro.")   
+      ENDIF(NOT PYTHONLIBS_FOUND)
+
+      LIST(REMOVE_AT BOOST_COMPONENTS_ ${PYTHON_IN_BOOST_COMPONENTS})
+      SET(BOOST_PYTHON_COMPONENT "python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")
+      LIST(APPEND BOOST_COMPONENTS_ ${BOOST_PYTHON_COMPONENT})
+    ENDIF()
+  ELSE(Boost_VERSION VERSION_GREATER 106699)
+    # Check if Python has been found
+    IF(NOT PYTHONLIBS_FOUND)
+      MESSAGE(FATAL_ERROR "PYTHON has not been found. You should first call FindPython before calling SEARCH_FOR_BOOST macro.")   
+    ENDIF(NOT PYTHONLIBS_FOUND)
+    IF(${PYTHON_VERSION_MAJOR} EQUAL 3) 
+      LIST(FIND BOOST_COMPONENTS python PYTHON_IN_BOOST_COMPONENTS)
+      SET(BOOST_COMPONENTS_ ${BOOST_COMPONENTS})
+      LIST(REMOVE_AT BOOST_COMPONENTS_ ${PYTHON_IN_BOOST_COMPONENTS})
+      IF(${PYTHON_IN_BOOST_COMPONENTS} GREATER -1)
+        IF(${UNIX})
+          SET(BOOST_PYTHON_COMPONENT "python-py${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")
+        ELSE(${UNIX})
+          SET(BOOST_PYTHON_COMPONENT "python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")
+        ENDIF(${UNIX})
+        LIST(APPEND BOOST_COMPONENTS_ ${BOOST_PYTHON_COMPONENT})
+      ENDIF(${PYTHON_IN_BOOST_COMPONENTS} GREATER -1)
+    ELSE(${PYTHON_VERSION_MAJOR} EQUAL 3) 
+      SET(BOOST_COMPONENTS_ ${BOOST_COMPONENTS})
+    ENDIF(${PYTHON_VERSION_MAJOR} EQUAL 3) 
+  ENDIF(Boost_VERSION VERSION_GREATER 106699)
+  
+  SET(BOOST_COMPONENTS ${BOOST_COMPONENTS_})
   FIND_PACKAGE(Boost ${BOOST_REQUIRED} COMPONENTS ${BOOST_COMPONENTS} REQUIRED)
 
   IF(NOT Boost_FOUND)
diff --git a/cmake/python.cmake b/cmake/python.cmake
index 887b356..5d3dec5 100644
--- a/cmake/python.cmake
+++ b/cmake/python.cmake
@@ -32,6 +32,11 @@
 #    or another version that the requested one.
 #
 
+#.rst:
+# .. variable:: PYTHON_SITELIB
+#
+#  Absolute path where Python files will be installed.
+
 IF(CMAKE_VERSION VERSION_LESS "3.2")
     SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/python ${CMAKE_MODULE_PATH})
     MESSAGE(WARNING "CMake versions older than 3.2 do not properly find Python. Custom macros are used to find it.")
@@ -166,10 +171,10 @@ MACRO(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME LIBRARYNAME TARGETNAME)
 ENDMACRO(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME)
 
 
-# PYTHON_INSTALL(MODULE FILE DEST)
-# --------------------------------
+#.rst:
+# .. command::  PYTHON_INSTALL(MODULE FILE DEST)
 #
-# Install a Python file and its associated compiled version.
+#  Install a Python file and its associated compiled version.
 #
 MACRO(PYTHON_INSTALL MODULE FILE DEST)
 
@@ -181,10 +186,10 @@ MACRO(PYTHON_INSTALL MODULE FILE DEST)
     DESTINATION "${DEST}/${MODULE}")
 ENDMACRO()
 
-# PYTHON_INSTALL_ON_SITE (MODULE FILE)
-# --------------------------------
+#.rst:
+# .. command:: PYTHON_INSTALL_ON_SITE (MODULE FILE)
 #
-# Install a Python file and its associated compiled version.
+#  Install a Python file and its associated compiled version in :cmake:variable:`PYTHON_SITELIB`.
 #
 MACRO(PYTHON_INSTALL_ON_SITE MODULE FILE)
 
@@ -287,6 +292,7 @@ MACRO(FIND_NUMPY)
   IF (NOT NUMPY_INCLUDE_DIRS)
     MESSAGE (FATAL_ERROR "Failed to detect numpy")
   ELSE ()
+    STRING(REGEX REPLACE "\n$" "" NUMPY_INCLUDE_DIRS "${NUMPY_INCLUDE_DIRS}")
     MESSAGE (STATUS " NUMPY_INCLUDE_DIRS=${NUMPY_INCLUDE_DIRS}")
   ENDIF()
 ENDMACRO()
