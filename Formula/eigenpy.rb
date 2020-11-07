class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support."
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.5.0/eigenpy-2.5.0.tar.gz"
  sha256 "bde935e93d721a62cdd78eb5622f030f04e19e48ed83266f30c7c5c7f59fcd74"
  head "https://github.com/stack-of-tasks/eigenpy.git", :branch => "devel"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "numpy"
  depends_on "eigen"
  depends_on "boost" => :build
  depends_on "boost-python3"
  depends_on "python@3.9"

  patch :DATA 

  bottle do
    root_url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.5.0"
    sha256 "ad51cd392533414036abfd096f83d9e6ae0e8b49851da55a923025d814a6a591" => :mojave
  end

  def install
    
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python#{pyver}/site-packages"
    
    mkdir "build" do
      args = *std_cmake_args
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
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8728614..2ce516f 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -66,6 +66,9 @@ ENDIF(WIN32)
 # ----------------------------------------------------
 ADD_PROJECT_DEPENDENCY(Eigen3 REQUIRED PKG_CONFIG_REQUIRES "eigen3 >= 3.0.5")
 
+SET_BOOST_DEFAULT_OPTIONS()
+EXPORT_BOOST_DEFAULT_OPTIONS()
+FIND_PACKAGE(Boost REQUIRED)
 SEARCH_FOR_BOOST_PYTHON()
 
 # ----------------------------------------------------
Submodule cmake contains modified content
Submodule cmake f4fca27..6803406:
diff --git a/cmake/.github/workflows/cmake.yml b/cmake/.github/workflows/cmake.yml
index 358980e..4de4780 100644
--- a/cmake/.github/workflows/cmake.yml
+++ b/cmake/.github/workflows/cmake.yml
@@ -9,7 +9,17 @@ jobs:
 
     steps:
     - uses: actions/checkout@v1
-    - name: Run tests
+
+    - name: Run project tests
+      run: |
+        set -e
+        set -x
+        cd _unittests
+        CMAKE_BIN="cmake"
+        $CMAKE_BIN --version
+        ./run_unit_tests.sh
+
+    - name: Run script tests
       run: |
         set -e
         set -x
diff --git a/cmake/Config.cmake.in b/cmake/Config.cmake.in
index 54f61d9..2ca89c9 100644
--- a/cmake/Config.cmake.in
+++ b/cmake/Config.cmake.in
@@ -49,9 +49,17 @@ if(_PKG_CONFIG_LIBS_LIST)
       string(REPLACE "-l" "" lib ${component})
       find_library(abs_lib_${lib} ${lib} HINTS ${LIBDIR_HINTS})
       if(NOT abs_lib_${lib})
-        message(STATUS "${lib} searched on ${_LIBDIR_HINTS} not FOUND.")
+        IF(_LIBDIR_HINTS)
+          message(STATUS "${lib} searched on ${_LIBDIR_HINTS} not FOUND.")
+        ELSE()
+          message(STATUS "${lib} not FOUND.")
+        ENDIF()
       else()
-        message(STATUS "${lib} searched on ${_LIBDIR_HINTS} FOUND. ${lib} at ${abs_lib_${lib}}")
+        IF(_LIBDIR_HINTS)
+          message(STATUS "${lib} searched on ${_LIBDIR_HINTS} FOUND. ${lib} at ${abs_lib_${lib}}")
+        ELSE()
+          message(STATUS "${lib} FOUND. ${lib} at ${abs_lib_${lib}}")
+        ENDIF()
         list(APPEND _PACKAGE_CONFIG_LIBRARIES "${abs_lib_${lib}}")
       endif()
       unset(abs_lib_${lib} CACHE)
@@ -69,9 +77,17 @@ if(_PKG_CONFIG_LIBS_LIST)
         string(REPLACE "-l" "" lib ${lib_info})
         find_library(abs_lib_${lib} ${lib} HINTS ${LIBDIR_HINTS})
         if(NOT abs_lib_${lib})
-          message(STATUS "${lib} searched on ${_LIBDIR_HINTS} not FOUND.")
+          IF(_LIBDIR_HINTS)
+            message(STATUS "${lib} searched on ${_LIBDIR_HINTS} not FOUND.")
+          ELSE()
+            message(STATUS "${lib} not FOUND.")
+          ENDIF()
         else()
-          message(STATUS "${lib} searched on ${_LIBDIR_HINTS} FOUND. ${lib} at ${abs_lib_${lib}}")
+          IF(_LIBDIR_HINTS)
+            message(STATUS "${lib} searched on ${_LIBDIR_HINTS} FOUND. ${lib} at ${abs_lib_${lib}}")
+          ELSE()
+            message(STATUS "${lib} FOUND. ${lib} at ${abs_lib_${lib}}")
+          ENDIF()
           list(APPEND _PACKAGE_CONFIG_LIBRARIES "${abs_lib_${lib}}")
         endif()
         unset(abs_lib_${lib} CACHE)
diff --git a/cmake/_unittests/cpp/CMakeLists.txt b/cmake/_unittests/cpp/CMakeLists.txt
new file mode 100644
index 0000000..ee46449
--- /dev/null
+++ b/cmake/_unittests/cpp/CMakeLists.txt
@@ -0,0 +1,30 @@
+cmake_minimum_required(VERSION 3.2)
+
+set(PROJECT_NAME jrl-cmakemodules-cpp)
+set(PROJECT_VERSION 0.0.0)
+set(PROJECT_DESCRIPTION "JRL CMake module - cpp")
+set(PROJECT_URL http://jrl-cmakemodules.readthedocs.io)
+set(PROJECT_USE_CMAKE_EXPORT TRUE)
+
+include(../../base.cmake)
+
+compute_project_args(PROJECT_ARGS LANGUAGES CXX)
+project(${PROJECT_NAME} ${PROJECT_ARGS})
+
+set(${PROJECT_NAME}_HEADERS
+  include/jrl_cmakemodule/lib.hh)
+
+add_library(jrl_cmakemodule_lib SHARED src/lib.cc)
+target_include_directories(jrl_cmakemodule_lib PUBLIC
+  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
+  $<INSTALL_INTERFACE:include>)
+
+install(TARGETS jrl_cmakemodule_lib
+        EXPORT ${TARGETS_EXPORT_NAME}
+        DESTINATION lib)
+
+add_executable(jrl_cmakemodule_main src/main.cc)
+target_link_libraries(jrl_cmakemodule_main jrl_cmakemodule_lib)
+
+install(TARGETS jrl_cmakemodule_main
+        DESTINATION main)
diff --git a/cmake/_unittests/cpp/include/jrl_cmakemodule/lib.hh b/cmake/_unittests/cpp/include/jrl_cmakemodule/lib.hh
new file mode 100644
index 0000000..98a3d34
--- /dev/null
+++ b/cmake/_unittests/cpp/include/jrl_cmakemodule/lib.hh
@@ -0,0 +1 @@
+void lib_function();
diff --git a/cmake/_unittests/cpp/src/lib.cc b/cmake/_unittests/cpp/src/lib.cc
new file mode 100644
index 0000000..af0036a
--- /dev/null
+++ b/cmake/_unittests/cpp/src/lib.cc
@@ -0,0 +1,7 @@
+#include <iostream>
+#include <jrl_cmakemodule/lib.hh>
+
+void lib_function()
+{
+  std::cout << "JRL CMake module - unittest - lib_function" << std::endl;
+}
diff --git a/cmake/_unittests/cpp/src/main.cc b/cmake/_unittests/cpp/src/main.cc
new file mode 100644
index 0000000..640e9ae
--- /dev/null
+++ b/cmake/_unittests/cpp/src/main.cc
@@ -0,0 +1,8 @@
+#include <iostream>
+#include <jrl_cmakemodule/lib.hh>
+
+int main()
+{
+  std::cout << "JRL CMake module - unittest - cpp" << std::endl;
+  lib_function();
+}
diff --git a/cmake/_unittests/dependency/CMakeLists.txt b/cmake/_unittests/dependency/CMakeLists.txt
new file mode 100644
index 0000000..9c0e0e6
--- /dev/null
+++ b/cmake/_unittests/dependency/CMakeLists.txt
@@ -0,0 +1,20 @@
+cmake_minimum_required(VERSION 3.2)
+
+set(PROJECT_NAME jrl-cmakemodules-dependency)
+set(PROJECT_VERSION 0.0.0)
+set(PROJECT_DESCRIPTION "JRL CMake module - dependency")
+set(PROJECT_URL http://jrl-cmakemodules.readthedocs.io)
+set(INSTALL_DOCUMENTATION OFF)
+
+include(../macros.cmake)
+
+include(../../base.cmake)
+
+compute_project_args(PROJECT_ARGS LANGUAGES CXX)
+project(${PROJECT_NAME} ${PROJECT_ARGS})
+
+add_project_dependency(jrl-cmakemodules-cpp REQUIRED)
+
+check_exist_target(jrl-cmakemodules-cpp::jrl_cmakemodule_lib "")
+
+check_exist_variable(jrl-cmakemodules-cpp_FOUND "")
diff --git a/cmake/_unittests/macros.cmake b/cmake/_unittests/macros.cmake
new file mode 100644
index 0000000..bda7753
--- /dev/null
+++ b/cmake/_unittests/macros.cmake
@@ -0,0 +1,11 @@
+macro(check_exist_variable name message)
+  if(NOT DEFINED ${name})
+    message(FATAL_ERROR "Variable ${name} not defined. ${message}")
+  endif()
+endmacro()
+
+macro(check_exist_target name message)
+  if(NOT TARGET ${name})
+    message(FATAL_ERROR "Expected target ${name}. ${message}")
+  endif()
+endmacro()
diff --git a/cmake/_unittests/python/CMakeLists.txt b/cmake/_unittests/python/CMakeLists.txt
new file mode 100644
index 0000000..8a468bd
--- /dev/null
+++ b/cmake/_unittests/python/CMakeLists.txt
@@ -0,0 +1,21 @@
+# Target-based approach should work from CMake 2.8.12 but it should fully work from 3.1
+cmake_minimum_required(VERSION 2.8.12)
+
+# These variables have to be defined before running SETUP_PROJECT
+set(PROJECT_NAME jrl-cmakemodules-python)
+set(PROJECT_VERSION 0.0.0)
+set(PROJECT_DESCRIPTION "JRL CMake module - python")
+set(PROJECT_URL http://jrl-cmakemodules.readthedocs.io)
+
+include(../macros.cmake)
+
+include(../../base.cmake)
+include(../../python.cmake)
+
+compute_project_args(PROJECT_ARGS)
+project(${PROJECT_NAME} ${PROJECT_ARGS})
+findpython()
+
+check_exist_variable(PYTHON_SITELIB "")
+
+python_install_on_site(jrl_cmakemodule python.py)
diff --git a/cmake/_unittests/python/jrl_cmakemodule/python.py b/cmake/_unittests/python/jrl_cmakemodule/python.py
new file mode 100644
index 0000000..e69de29
diff --git a/cmake/_unittests/run_unit_tests.sh b/cmake/_unittests/run_unit_tests.sh
new file mode 100755
index 0000000..a66cb48
--- /dev/null
+++ b/cmake/_unittests/run_unit_tests.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+unittests="python cpp dependency"
+
+# Code for running a specific unit test
+# For unit test foo, function `run_foo` is executed if defined.
+# Otherwise, a default procedure is run.
+
+# function run_foo
+# {
+#   echo "run_foo"
+# }
+
+function run_default()
+{
+  $CMAKE_BIN ${cmake_options} "$1"
+  make all
+  make install
+}
+
+function run_cpp()
+{
+  run_default $here/cpp
+}
+
+# The code below run all the unit tests
+here="`pwd`"
+rm -rf build install
+mkdir build install
+
+if [[ -z "${CMAKE_BIN}" ]]; then
+  CMAKE_BIN=cmake
+fi
+cmake_options="-DCMAKE_INSTALL_PREFIX='${here}/install'"
+export CMAKE_PREFIX_PATH=$here/install
+
+for unittest in ${unittests}; do
+  mkdir build/${unittest}
+  cd build/${unittest}
+  if [[ "$(type -t run_${unittest})" == "function" ]]; then
+    run_${unittest}
+  else
+    run_default "$here/$unittest"
+  fi
+  cd "$here"
+done
diff --git a/cmake/base.cmake b/cmake/base.cmake
index 86f7323..52ddab9 100644
--- a/cmake/base.cmake
+++ b/cmake/base.cmake
@@ -83,10 +83,16 @@
 #     project properties. Not setting this variable when no target is present
 #     will result in an error.
 #
+#   .. variable:: PROJECT_JRL_CMAKE_MODULE_DIR
+#
+#     This variable provides the full path pointing to the JRL cmake module.
+#
 #   Macros
 #   ------
 #
 
+SET(PROJECT_JRL_CMAKE_MODULE_DIR ${CMAKE_CURRENT_LIST_DIR})
+
 # Please note that functions starting with an underscore are internal
 # functions and should not be used directly.
 
@@ -99,7 +105,6 @@ INCLUDE(${CMAKE_CURRENT_LIST_DIR}/dist.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/distcheck.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/doxygen.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/header.cmake)
-INCLUDE(${CMAKE_CURRENT_LIST_DIR}/pkg-config.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/uninstall.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/install-data.cmake)
 INCLUDE(${CMAKE_CURRENT_LIST_DIR}/release.cmake)
@@ -147,7 +152,11 @@ SET(SAVED_PROJECT_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
 IF(PROJECT_VERSION MATCHES UNKNOWN)
   SET(PROJECT_VERSION_FULL "")
 ELSE(PROJECT_VERSION MATCHES UNKNOWN)
+  IF(PROJECT_VERSION_PATCH)
   SET(PROJECT_VERSION_FULL "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
+  ELSE(PROJECT_VERSION_PATCH)
+    SET(PROJECT_VERSION_FULL "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")
+  ENDIF(PROJECT_VERSION_PATCH)
 ENDIF(PROJECT_VERSION MATCHES UNKNOWN)
 
 # Set a script to run after project called
@@ -158,10 +167,12 @@ SET(CMAKE_PROJECT_${PROJECT_NAME}_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/post-projec
 VARIABLE_WATCH(CMAKE_CURRENT_LIST_DIR SETUP_PROJECT_FINALIZE_HOOK)
 FUNCTION(SETUP_PROJECT_FINALIZE_HOOK VARIABLE ACCESS)
   IF("${${VARIABLE}}" STREQUAL "")
+    SET(CMAKE_CURRENT_LIST_DIR ${PROJECT_JRL_CMAKE_MODULE_DIR})
     SETUP_PROJECT_FINALIZE()
     IF(PROJECT_USE_CMAKE_EXPORT)
       SETUP_PROJECT_PACKAGE_FINALIZE()
     ENDIF()
+    SET(CMAKE_CURRENT_LIST_DIR "") # restore value
   ENDIF()
 ENDFUNCTION()
 
diff --git a/cmake/boost.cmake b/cmake/boost.cmake
index 6177257..63c77f4 100644
--- a/cmake/boost.cmake
+++ b/cmake/boost.cmake
@@ -32,25 +32,33 @@ FUNCTION(SEARCH_FOR_BOOST_COMPONENT boost_python_name found)
 ENDFUNCTION(SEARCH_FOR_BOOST_COMPONENT boost_python_name found)
 
 IF(CMAKE_VERSION VERSION_LESS "3.12")
-  SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/boost ${CMAKE_MODULE_PATH})
+  SET(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/boost ${CMAKE_MODULE_PATH})
   MESSAGE(STATUS "CMake versions older than 3.12 may warn when looking to Boost components. Custom macros are used to find it.")
 ENDIF(CMAKE_VERSION VERSION_LESS "3.12")
 
 #.rst:
-# .. variable:: BOOST_COMPONENTS
+# .. command:: SET_BOOST_DEFAULT_OPTIONS
 #
-# This variable is *deprecated*. See :cmake:command:`SEARCH_FOR_BOOST` for more info.
-#
-#  Controls the components to be detected by the deprecated macro :cmake:command:`SEARCH_FOR_BOOST`.
-#  If this variable is not defined, it defaults to the following component
-#  list:
+#  This function allows to set up the default options for detecting Boost components.
+# 
+MACRO(SET_BOOST_DEFAULT_OPTIONS)
+  SET(Boost_USE_STATIC_LIBS OFF)
+  SET(Boost_USE_MULTITHREADED ON)
+  SET(Boost_NO_BOOST_CMAKE ON) 
+ENDMACRO(SET_BOOST_DEFAULT_OPTIONS)
+
+#.rst:
+# .. command:: EXPORT_BOOST_DEFAULT_OPTIONS
 #
-#  - Filesystem
-#  - Program_options
-#  - System
-#  - Thread
-#  - Unit_test_framework
+#  This function allows to export the default options for detecting Boost components.
+# 
+MACRO(EXPORT_BOOST_DEFAULT_OPTIONS)
+  LIST(INSERT _PACKAGE_CONFIG_DEPENDENCIES_FIND_PACKAGE 0 "SET(Boost_USE_STATIC_LIBS OFF);SET(Boost_USE_MULTITHREADED ON);SET(Boost_NO_BOOST_CMAKE ON)")
+  LIST(INSERT _PACKAGE_CONFIG_DEPENDENCIES_FIND_DEPENDENCY 0 "SET(Boost_USE_STATIC_LIBS OFF);SET(Boost_USE_MULTITHREADED ON);SET(Boost_NO_BOOST_CMAKE ON)")
+ENDMACRO(EXPORT_BOOST_DEFAULT_OPTIONS)
+
 #
+#.rst
 # .. command:: SEARCH_FOR_BOOST_PYTHON([REQUIRED])
 #
 #  Find boost-python component.
@@ -68,18 +76,7 @@ MACRO(SEARCH_FOR_BOOST_PYTHON)
     SET(BOOST_PYTHON_REQUIRED REQUIRED)
   ENDIF(_BOOST_PYTHON_REQUIRED)
 
-  IF(NOT Boost_FOUND)
-    # Set Boost default settings
-    # First try to find Boost to get the version
-    FIND_PACKAGE(Boost ${BOOST_PYTHON_REQUIRED})
-    STRING(REPLACE "_" "." Boost_SHORT_VERSION ${Boost_LIB_VERSION})
-    SET(Boost_USE_STATIC_LIBS OFF)
-    SET(Boost_USE_MULTITHREADED ON)
-    IF("${Boost_SHORT_VERSION}" VERSION_GREATER "1.70" OR "${Boost_SHORT_VERSION}" VERSION_EQUAL "1.70")
-      SET(BUILD_SHARED_LIBS ON) 
-      SET(Boost_NO_BOOST_CMAKE ON) 
-    ENDIF("${Boost_SHORT_VERSION}" VERSION_GREATER "1.70" OR "${Boost_SHORT_VERSION}" VERSION_EQUAL "1.70")
-  ENDIF(NOT Boost_FOUND)
+  SET_BOOST_DEFAULT_OPTIONS()
 
   IF(NOT PYTHONLIBS_FOUND)
     MESSAGE(FATAL_ERROR "Python has not been found. You should first call FindPython before calling SEARCH_FOR_BOOST_PYTHON macro.")
@@ -89,11 +86,13 @@ MACRO(SEARCH_FOR_BOOST_PYTHON)
   SET(BOOST_PYTHON_COMPONENT_LIST
     "python${PYTHON_VERSION_MAJOR}"
     "python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}"
-    "python-py${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")
+    "python-py${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}"
+    "python")
 
   SET(BOOST_PYTHON_FOUND FALSE)
   FOREACH(BOOST_PYTHON_COMPONENT ${BOOST_PYTHON_COMPONENT_LIST})
     SEARCH_FOR_BOOST_COMPONENT(${BOOST_PYTHON_COMPONENT} BOOST_PYTHON_FOUND)
+    MESSAGE(STATUS "found ${BOOST_PYTHON_COMPONENT}: ${BOOST_PYTHON_FOUND}")
     IF(BOOST_PYTHON_FOUND)
       SET(BOOST_PYTHON_NAME ${BOOST_PYTHON_COMPONENT})
       BREAK()
@@ -103,6 +102,7 @@ MACRO(SEARCH_FOR_BOOST_PYTHON)
   # If boost-python has not been found, warn the user, and look for just "python"
   IF(NOT BOOST_PYTHON_FOUND)
     MESSAGE(WARNING "Impossible to check Boost.Python version. Trying with 'python'.")
+    SET(BOOST_PYTHON_NAME "python")
   ENDIF(NOT BOOST_PYTHON_FOUND)
 
   FIND_PACKAGE(Boost ${BOOST_PYTHON_REQUIRED} COMPONENTS ${BOOST_PYTHON_NAME})
diff --git a/cmake/dist.cmake b/cmake/dist.cmake
index a11f7cc..5bd5e34 100644
--- a/cmake/dist.cmake
+++ b/cmake/dist.cmake
@@ -31,9 +31,9 @@ MACRO(_SETUP_PROJECT_DIST)
     FIND_PROGRAM(GPG gpg)
 
     IF(APPLE)
-      SET(GIT_ARCHIVE_ALL ${PROJECT_SOURCE_DIR}/cmake/git-archive-all.py)
+      SET(GIT_ARCHIVE_ALL ${PROJECT_JRL_CMAKE_MODULE_DIR}/git-archive-all.py)
     ELSE(APPLE)
-      SET(GIT_ARCHIVE_ALL ${PROJECT_SOURCE_DIR}/cmake/git-archive-all.sh)
+      SET(GIT_ARCHIVE_ALL ${PROJECT_JRL_CMAKE_MODULE_DIR}/git-archive-all.sh)
     ENDIF(APPLE)
 
     # Use git-archive-all.sh to generate distributable source code
@@ -50,7 +50,7 @@ MACRO(_SETUP_PROJECT_DIST)
       && ${TAR} xf ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.tar
       && echo "${PROJECT_VERSION}" >
          ${CMAKE_BINARY_DIR}/${PROJECT_NAME}${PROJECT_SUFFIX}-${PROJECT_VERSION}/.version
-      && ${PROJECT_SOURCE_DIR}/cmake/gitlog-to-changelog >
+      && ${PROJECT_JRL_CMAKE_MODULE_DIR}/gitlog-to-changelog >
       ${CMAKE_BINARY_DIR}/${PROJECT_NAME}${PROJECT_SUFFIX}-${PROJECT_VERSION}/ChangeLog
       && rm -f ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.tar
       WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
diff --git a/cmake/doxygen.cmake b/cmake/doxygen.cmake
index a6a815d..94d85ac 100644
--- a/cmake/doxygen.cmake
+++ b/cmake/doxygen.cmake
@@ -539,8 +539,8 @@ MACRO(_SETUP_PROJECT_DOCUMENTATION)
       _set_if_undefined(DOXYGEN_HTML_FOOTER     "${CMAKE_CURRENT_BINARY_DIR}/doc/footer.html")
       _set_if_undefined(DOXYGEN_HTML_STYLESHEET "${CMAKE_CURRENT_BINARY_DIR}/doc/doxygen.css")
     ELSE (DOXYGEN_USE_TEMPLATE_CSS)
-      _set_if_undefined(DOXYGEN_HTML_FOOTER     "${PROJECT_SOURCE_DIR}/cmake/doxygen/footer.html")
-      _set_if_undefined(DOXYGEN_HTML_STYLESHEET "${PROJECT_SOURCE_DIR}/cmake/doxygen/doxygen.css")
+      _set_if_undefined(DOXYGEN_HTML_FOOTER     "${PROJECT_JRL_CMAKE_MODULE_DIR}/doxygen/footer.html")
+      _set_if_undefined(DOXYGEN_HTML_STYLESHEET "${PROJECT_JRL_CMAKE_MODULE_DIR}/doxygen/doxygen.css")
     ENDIF (DOXYGEN_USE_TEMPLATE_CSS)
 
     ADD_CUSTOM_COMMAND(
@@ -563,7 +563,7 @@ MACRO(_SETUP_PROJECT_DOCUMENTATION)
 
     # Install MathJax minimal version.
     IF("${DOXYGEN_USE_MATHJAX}" STREQUAL "YES")
-      FILE(COPY ${PROJECT_SOURCE_DIR}/cmake/doxygen/MathJax
+      FILE(COPY ${PROJECT_JRL_CMAKE_MODULE_DIR}/doxygen/MathJax
            DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/doc/doxygen-html)
     ENDIF()
 
@@ -644,7 +644,7 @@ MACRO(_SETUP_PROJECT_DOCUMENTATION_FINALIZE)
       MESSAGE(STATUS "Doxygen rendering: using LaTeX backend")
       SET(DOXYGEN_HEADER_NAME "header.html")
     ENDIF()
-    _set_if_undefined (DOXYGEN_HTML_HEADER "${PROJECT_SOURCE_DIR}/cmake/doxygen/${DOXYGEN_HEADER_NAME}")
+    _set_if_undefined (DOXYGEN_HTML_HEADER "${PROJECT_JRL_CMAKE_MODULE_DIR}/doxygen/${DOXYGEN_HEADER_NAME}")
 
     IF(INSTALL_DOCUMENTATION)
       # Find doxytag files
diff --git a/cmake/find-external/CppAD/Findcppad.cmake b/cmake/find-external/CppAD/Findcppad.cmake
index 5b337ed..429f8e1 100644
--- a/cmake/find-external/CppAD/Findcppad.cmake
+++ b/cmake/find-external/CppAD/Findcppad.cmake
@@ -16,10 +16,12 @@
 FIND_PATH(cppad_INCLUDE_DIR
   NAMES cppad/configure.hpp
   PATHS ${cppad_PREFIX}
+  PATH_SUFFIXES include
   )
 FIND_LIBRARY(cppad_LIBRARY
   NAMES cppad_lib
   PATHS ${cppad_PREFIX}
+  PATH_SUFFIXES lib
   )
 
 IF(cppad_INCLUDE_DIR AND EXISTS "${cppad_INCLUDE_DIR}/cppad/configure.hpp")
diff --git a/cmake/find-external/CppAD/Findcppadcg.cmake b/cmake/find-external/CppAD/Findcppadcg.cmake
index ae97e8d..9a0f0cc 100644
--- a/cmake/find-external/CppAD/Findcppadcg.cmake
+++ b/cmake/find-external/CppAD/Findcppadcg.cmake
@@ -14,6 +14,7 @@
 FIND_PATH(cppadcg_INCLUDE_DIR
   NAMES cppad/cg.hpp
   PATHS ${cppadcg_PREFIX}
+  PATH_SUFFIXES include
   )
 
 IF(cppadcg_INCLUDE_DIR AND EXISTS "${cppadcg_INCLUDE_DIR}/cppad/cg/configure.hpp")
diff --git a/cmake/header.cmake b/cmake/header.cmake
index 2fd0268..e0c592a 100644
--- a/cmake/header.cmake
+++ b/cmake/header.cmake
@@ -89,7 +89,7 @@ MACRO(_SETUP_PROJECT_HEADER)
 
   # Generate deprecated.hh header.
   CONFIGURE_FILE(
-    ${PROJECT_SOURCE_DIR}/cmake/deprecated.hh.cmake
+    ${CMAKE_CURRENT_LIST_DIR}/deprecated.hh.cmake
     ${CMAKE_CURRENT_BINARY_DIR}/include/${HEADER_DIR}/deprecated.${PROJECT_CUSTOM_HEADER_EXTENSION}
     @ONLY
     )
@@ -104,7 +104,7 @@ MACRO(_SETUP_PROJECT_HEADER)
 
   # Generate warning.hh header.
   CONFIGURE_FILE(
-    ${PROJECT_SOURCE_DIR}/cmake/warning.hh.cmake
+    ${CMAKE_CURRENT_LIST_DIR}/warning.hh.cmake
     ${CMAKE_CURRENT_BINARY_DIR}/include/${HEADER_DIR}/warning.${PROJECT_CUSTOM_HEADER_EXTENSION}
     @ONLY
     )
@@ -123,7 +123,7 @@ MACRO(_SETUP_PROJECT_HEADER)
   # in the top-level directory of the build tree.
   # Therefore it must not be included by any distributed header.
   CONFIGURE_FILE(
-    ${PROJECT_SOURCE_DIR}/cmake/config.h.cmake
+    ${CMAKE_CURRENT_LIST_DIR}/config.h.cmake
     ${CMAKE_CURRENT_BINARY_DIR}/config.h
     )
 
@@ -171,7 +171,7 @@ FUNCTION(GENERATE_CONFIGURATION_HEADER
 
   # Generate the header.
   CONFIGURE_FILE(
-    ${PROJECT_SOURCE_DIR}/cmake/config.hh.cmake
+    ${CMAKE_CURRENT_LIST_DIR}/config.hh.cmake
     ${CMAKE_CURRENT_BINARY_DIR}/include/${HEADER_DIR}/${FILENAME}
     @ONLY
     )
diff --git a/cmake/hpp.cmake b/cmake/hpp.cmake
index 71b712e..b43b350 100644
--- a/cmake/hpp.cmake
+++ b/cmake/hpp.cmake
@@ -62,8 +62,8 @@ IF (NOT DEFINED PROJECT_URL)
   SET(PROJECT_URL "https://github.com/${PROJECT_ORG}/${PROJECT_NAME}")
 ENDIF (NOT DEFINED PROJECT_URL)
 
-INCLUDE(cmake/base.cmake)
-INCLUDE(cmake/hpp/doc.cmake)
+INCLUDE(${CMAKE_CURRENT_LIST_DIR}/base.cmake)
+INCLUDE(${CMAKE_CURRENT_LIST_DIR}/hpp/doc.cmake)
 
 # Activate hpp-util logging if requested
 SET (HPP_DEBUG FALSE CACHE BOOL "trigger hpp-util debug output")
diff --git a/cmake/hpp/doc.cmake b/cmake/hpp/doc.cmake
index f452f5c..894a6af 100644
--- a/cmake/hpp/doc.cmake
+++ b/cmake/hpp/doc.cmake
@@ -23,7 +23,7 @@
 # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 IF(NOT DEFINED DOXYGEN_LAYOUT_FILE)
-  SET(DOXYGEN_LAYOUT_FILE "${CMAKE_SOURCE_DIR}/cmake/hpp/doc/layout.xml")
+  SET(DOXYGEN_LAYOUT_FILE "${CMAKE_CURRENT_LIST_DIR}/doc/layout.xml")
 ENDIF()
 IF(NOT DEFINED DOXYGEN_USE_TEMPLATE_CSS)
   SET(DOXYGEN_USE_TEMPLATE_CSS TRUE)
diff --git a/cmake/idl.cmake b/cmake/idl.cmake
index 5b7ce43..c0b3793 100644
--- a/cmake/idl.cmake
+++ b/cmake/idl.cmake
@@ -160,7 +160,7 @@ MACRO(GENERATE_IDL_PYTHON FILENAME DIRECTORY)
   ENDIF(${OMNIIDL} STREQUAL OMNIIDL-NOTFOUND)
 
   IF(_omni_ENABLE_DOCSTRING AND PYTHON_VERSION_MAJOR EQUAL 3)
-    SET(_omniidl_args -p${CMAKE_SOURCE_DIR}/cmake/hpp/idl -bomniidl_be_python_with_docstring -K)
+    SET(_omniidl_args -p${CMAKE_CURRENT_LIST_DIR}/hpp/idl -bomniidl_be_python_with_docstring -K)
   ELSE()
     SET(_omniidl_args -bpython)
   ENDIF()
diff --git a/cmake/msvc-specific.cmake b/cmake/msvc-specific.cmake
index d54cf6b..233bd0c 100644
--- a/cmake/msvc-specific.cmake
+++ b/cmake/msvc-specific.cmake
@@ -104,10 +104,10 @@ MACRO(GENERATE_MSVC_DOT_USER_FILE NAME)
     endif()
     
     GET_MSVC_VERSION()
-    set(DOT_USER_TEMPLATE_PATH ${CMAKE_SOURCE_DIR}/cmake/msvc.vcxproj.user.in)
+    set(DOT_USER_TEMPLATE_PATH ${PROJECT_JRL_CMAKE_MODULE_DIR}/msvc.vcxproj.user.in)
     set(DOT_USER_FILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vcxproj.user)
     configure_file(${DOT_USER_TEMPLATE_PATH} ${DOT_USER_FILE_PATH})
     
     unset(MSVC_DOT_USER_ADDITIONAL_PATH_DOT_USER)
   endif(MSVC)
-ENDMACRO(GENERATE_MSVC_DOT_USER_FILE)
\ No newline at end of file
+ENDMACRO(GENERATE_MSVC_DOT_USER_FILE)
diff --git a/cmake/openhrpcontroller.cmake b/cmake/openhrpcontroller.cmake
index 53b4bb3..702da5e 100644
--- a/cmake/openhrpcontroller.cmake
+++ b/cmake/openhrpcontroller.cmake
@@ -14,7 +14,7 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 # OpenRTM-aist
-INCLUDE(cmake/openrtm.cmake)
+INCLUDE(${CMAKE_CURRENT_LIST_DIR}/openrtm.cmake)
 
 macro(create_simple_controller CONTROLLER_NAME)
   openrtm()
diff --git a/cmake/openrtm.cmake b/cmake/openrtm.cmake
index 161745e..25630c5 100644
--- a/cmake/openrtm.cmake
+++ b/cmake/openrtm.cmake
@@ -16,7 +16,7 @@
 # OpenRTM-aist
 macro(openrtm)
 
-  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake/find-external/OpenRTM)
+  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/find-external/OpenRTM)
 
   find_package(OpenRTM REQUIRED)
   set(ADDITIONAL_SYMBOL "")
diff --git a/cmake/package-config.cmake b/cmake/package-config.cmake
index 76946e5..fd9e8e0 100644
--- a/cmake/package-config.cmake
+++ b/cmake/package-config.cmake
@@ -171,7 +171,7 @@ else()
 endif()
 
 configure_package_config_file(
-    "cmake/Config.cmake.in"
+    "${PROJECT_JRL_CMAKE_MODULE_DIR}/Config.cmake.in"
     "${PROJECT_CONFIG}"
     INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
 )
@@ -229,7 +229,7 @@ macro(PROJECT_INSTALL_COMPONENT COMPONENT)
   set(COMPONENT_EXTRA_MACRO "${PARSED_ARGN_EXTRA_MACRO}")
   include(CMakePackageConfigHelpers)
   configure_package_config_file(
-      "${CMAKE_SOURCE_DIR}/cmake/componentConfig.cmake.in"
+      "${PROJECT_JRL_CMAKE_MODULE_DIR}/componentConfig.cmake.in"
       "${COMPONENT_CONFIG}"
       INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
       NO_CHECK_REQUIRED_COMPONENTS_MACRO
diff --git a/cmake/pkg-config.cmake b/cmake/pkg-config.cmake
index 6cdac7e..c5600f7 100644
--- a/cmake/pkg-config.cmake
+++ b/cmake/pkg-config.cmake
@@ -13,7 +13,7 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-INCLUDE(cmake/shared-library.cmake)
+INCLUDE(${CMAKE_CURRENT_LIST_DIR}/shared-library.cmake)
 
 FIND_PACKAGE(PkgConfig)
 
@@ -121,7 +121,7 @@ MACRO(_SETUP_PROJECT_PKG_CONFIG)
     _PKG_CONFIG_REQUIRES
     _PKG_CONFIG_REQUIRES_DEBUG
     _PKG_CONFIG_REQUIRES_OPTIMIZED
-    _PKG_CONFIG_COMPILE_TIME_REQUIRES 
+    _PKG_CONFIG_COMPILE_TIME_REQUIRES
     _PKG_CONFIG_CONFLICTS
     _PKG_CONFIG_LIBS
     _PKG_CONFIG_LIBS_DEBUG
@@ -159,7 +159,7 @@ MACRO(_SETUP_PROJECT_PKG_CONFIG_FINALIZE_DEBUG)
   ENDIF()
   _list_join(_PKG_CONFIG_REQUIRES ", " _PKG_CONFIG_REQUIRES_LIST)
   CONFIGURE_FILE(
-    "${PROJECT_SOURCE_DIR}/cmake/pkg-config.pc.cmake"
+    "${CMAKE_CURRENT_LIST_DIR}/pkg-config.pc.cmake"
     "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}${PKGCONFIG_POSTFIX}.pc"
     )
   # Restore altered variables
@@ -202,7 +202,7 @@ MACRO(_SETUP_PROJECT_PKG_CONFIG_FINALIZE_OPTIMIZED)
   ENDIF(DEFINED CUSTOM_PKG_CONFIG_FILENAME)
   # Generate the pkg-config file.
   CONFIGURE_FILE(
-    "${PROJECT_SOURCE_DIR}/cmake/pkg-config.pc.cmake"
+    "${PROJECT_JRL_CMAKE_MODULE_DIR}/pkg-config.pc.cmake"
     "${CMAKE_CURRENT_BINARY_DIR}/${_PKG_CONFIG_FILENAME}"
     )
   # Restore altered variables
@@ -247,7 +247,7 @@ ENDMACRO(_SETUP_PROJECT_PKG_CONFIG_FINALIZE)
 
 # _PARSE_PKG_CONFIG_STRING (PKG_CONFIG_STRING _PKG_LIB_NAME_VAR _PKG_PREFIX_VAR _PKG_CONFIG_STRING_NOSPACE_VAR)
 # ----------------------------------------------------------
-# 
+#
 # Retrieve from the pkg-config string:
 # - the library name,
 # - the prefix used for CMake variable names,
@@ -290,7 +290,7 @@ ENDMACRO()
 #              the package becomes required.
 #
 # COMPILE_TIME_ONLY : if set to 1, the package is only requiered at compile time and won't
-#                     appear as a dependency inside the *.pc file. 
+#                     appear as a dependency inside the *.pc file.
 #
 # PKG_CONFIG_STRING	: string passed to pkg-config to check the version.
 #			  Typically, this string looks like:
@@ -755,7 +755,7 @@ MACRO(PKG_CONFIG_APPEND_LIBS LIBS)
         IF(SUFFIX_SET)
           GET_TARGET_PROPERTY(LIB_SUFFIX ${LIB} SUFFIX)
         ENDIF(SUFFIX_SET)
-        
+
         GET_PROPERTY(PREFIX_SET TARGET ${LIB} PROPERTY PREFIX SET)
         IF(PREFIX_SET)
           GET_TARGET_PROPERTY(LIB_PREFIX ${LIB} PREFIX)
diff --git a/cmake/post-project.cmake b/cmake/post-project.cmake
index 55d22bc..734c18c 100644
--- a/cmake/post-project.cmake
+++ b/cmake/post-project.cmake
@@ -8,6 +8,7 @@ INCLUDE(${CMAKE_CURRENT_LIST_DIR}/GNUInstallDirs.cmake)
 SET(CMAKE_INSTALL_FULL_PKGLIBDIR ${CMAKE_INSTALL_FULL_LIBDIR}/${PROJECT_NAME})
 SET(CMAKE_INSTALL_PKGLIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME})
 
+INCLUDE(${CMAKE_CURRENT_LIST_DIR}/pkg-config.cmake)
 IF(DEFINED PROJECT_DEBUG_POSTFIX)
   SET(CMAKE_DEBUG_POSTFIX ${PROJECT_DEBUG_POSTFIX})
   STRING(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type)
diff --git a/cmake/python.cmake b/cmake/python.cmake
index db414f9..44e38e6 100644
--- a/cmake/python.cmake
+++ b/cmake/python.cmake
@@ -49,7 +49,7 @@
 #  Portable suffix of C++ Python modules.
 
 IF(CMAKE_VERSION VERSION_LESS "3.2")
-    SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/python ${CMAKE_MODULE_PATH})
+    SET(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/python ${CMAKE_MODULE_PATH})
     MESSAGE(STATUS "CMake versions older than 3.2 do not properly find Python. Custom macros are used to find it.")
 ENDIF(CMAKE_VERSION VERSION_LESS "3.2")
 
@@ -72,15 +72,22 @@ MACRO(FINDPYTHON)
     ENDIF()
 
     IF(PYTHON_EXECUTABLE)
+      IF(NOT EXISTS ${PYTHON_EXECUTABLE})
+        MESSAGE(FATAL_ERROR "${PYTHON_EXECUTABLE} is not a valid path to the Python executable") 
+      ENDIF()
       EXECUTE_PROCESS(
         COMMAND ${PYTHON_EXECUTABLE} --version
         WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
+        RESULT_VARIABLE _PYTHON_VERSION_RESULT_VARIABLE
         OUTPUT_VARIABLE _PYTHON_VERSION_OUTPUT
         ERROR_VARIABLE _PYTHON_VERSION_OUTPUT
         OUTPUT_STRIP_TRAILING_WHITESPACE
         ERROR_STRIP_TRAILING_WHITESPACE
         )
 
+      IF(NOT "${_PYTHON_VERSION_RESULT_VARIABLE}" STREQUAL "0")
+        MESSAGE(FATAL_ERROR "${PYTHON_EXECUTABLE} --version did not succeed.")
+      ENDIF(NOT "${_PYTHON_VERSION_RESULT_VARIABLE}" STREQUAL "0")
       STRING(REGEX REPLACE "Python " "" _PYTHON_VERSION ${_PYTHON_VERSION_OUTPUT})
       STRING(REGEX REPLACE "\\." ";" _PYTHON_VERSION ${_PYTHON_VERSION})
       LIST(GET _PYTHON_VERSION 0 _PYTHON_VERSION_MAJOR)
@@ -175,7 +182,9 @@ MACRO(FINDPYTHON)
   MESSAGE(STATUS "PythonLibraryDirs: ${PYTHON_LIBRARY_DIRS}")
   MESSAGE(STATUS "PythonLibVersionString: ${PYTHONLIBS_VERSION_STRING}")
 
-  IF(NOT PYTHON_SITELIB)
+  IF(PYTHON_SITELIB)
+    FILE(TO_CMAKE_PATH "${PYTHON_SITELIB}" PYTHON_SITELIB)
+  ELSE(PYTHON_SITELIB)
     # Use either site-packages (default) or dist-packages (Debian packages) directory
     OPTION(PYTHON_DEB_LAYOUT "Enable Debian-style Python package layout" OFF)
     # ref. https://docs.python.org/3/library/site.html
@@ -203,7 +212,7 @@ MACRO(FINDPYTHON)
     IF(PYTHON_PACKAGES_DIR)
       STRING(REGEX REPLACE "(site-packages|dist-packages)" "${PYTHON_PACKAGES_DIR}" PYTHON_SITELIB "${PYTHON_SITELIB}")
     ENDIF(PYTHON_PACKAGES_DIR)
-  ENDIF(NOT PYTHON_SITELIB)
+  ENDIF(PYTHON_SITELIB)
 
   MESSAGE(STATUS "Python site lib: ${PYTHON_SITELIB}")
 
@@ -278,7 +287,7 @@ MACRO(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME LIBRARYNAME TARGETNAME)
 
   # By default the __init__.py file is installed.
   SET(INSTALL_INIT_PY 1)
-  SET(SOURCE_PYTHON_MODULE "cmake/dynamic_graph/python-module-py.cc")
+  SET(SOURCE_PYTHON_MODULE "${CMAKE_CURRENT_LIST_DIR}/dynamic_graph/python-module-py.cc")
 
   # Check if there is optional parameters.
   set(extra_macro_args ${ARGN})
@@ -341,7 +350,7 @@ MACRO(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME LIBRARYNAME TARGETNAME)
   IF (${INSTALL_INIT_PY} EQUAL 1)
 
     CONFIGURE_FILE(
-      ${PROJECT_SOURCE_DIR}/cmake/dynamic_graph/submodule/__init__.py.cmake
+      ${CMAKE_CURRENT_LIST_DIR}/dynamic_graph/submodule/__init__.py.cmake
       ${PROJECT_BINARY_DIR}/src/dynamic_graph/${SUBMODULENAME}/__init__.py
       )
 
@@ -404,7 +413,7 @@ MACRO(PYTHON_BUILD MODULE FILE)
     PRE_BUILD
     COMMAND
     "${PYTHON_EXECUTABLE}"
-    "${PROJECT_SOURCE_DIR}/cmake/compile.py"
+    "${PROJECT_JRL_CMAKE_MODULE_DIR}/compile.py"
     "${CMAKE_CURRENT_SOURCE_DIR}"
     "${CMAKE_CURRENT_BINARY_DIR}"
     "${MODULE}/${FILE}"
@@ -440,7 +449,7 @@ MACRO(PYTHON_INSTALL_BUILD MODULE FILE DEST)
   INSTALL(CODE
     "EXECUTE_PROCESS(COMMAND
     \"${PYTHON_EXECUTABLE}\"
-    \"${PROJECT_SOURCE_DIR}/cmake/compile.py\"
+    \"${CMAKE_CURRENT_LIST_DIR}/compile.py\"
     \"${CMAKE_CURRENT_BINARY_DIR}\"
     \"${CMAKE_CURRENT_BINARY_DIR}\"
     \"${MODULE}/${FILE}\")
diff --git a/cmake/uninstall.cmake b/cmake/uninstall.cmake
index 828315a..ae81061 100644
--- a/cmake/uninstall.cmake
+++ b/cmake/uninstall.cmake
@@ -22,7 +22,7 @@ MACRO(_SETUP_PROJECT_UNINSTALL)
   # FIXME: it is utterly stupid to rely on the install manifest.
   # Can't we just remember what we install ?!
   CONFIGURE_FILE(
-    "${PROJECT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
+    "${CMAKE_CURRENT_LIST_DIR}/cmake_uninstall.cmake.in"
     "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
     IMMEDIATE
     @ONLY
@@ -35,7 +35,7 @@ MACRO(_SETUP_PROJECT_UNINSTALL)
     )
 
   CONFIGURE_FILE(
-    "${PROJECT_SOURCE_DIR}/cmake/cmake_reinstall.cmake.in"
+    "${CMAKE_CURRENT_LIST_DIR}/cmake_reinstall.cmake.in"
     "${PROJECT_BINARY_DIR}/cmake/cmake_reinstall.cmake.configured"
     )
   IF(DEFINED CMAKE_BUILD_TYPE)
diff --git a/cmake/version-script.cmake b/cmake/version-script.cmake
index c917847..226cb57 100644
--- a/cmake/version-script.cmake
+++ b/cmake/version-script.cmake
@@ -21,7 +21,7 @@ INCLUDE(CheckCCompilerFlag)
 # Internal macro to check if version scripts are supported by the current
 # linker.
 MACRO(_CHECK_VERSION_SCRIPT_SUPPORT)
-  SET(CMAKE_REQUIRED_FLAGS "-Wl,--version-script=${PROJECT_SOURCE_DIR}/cmake/version-script-test.lds")
+  SET(CMAKE_REQUIRED_FLAGS "-Wl,--version-script=${CMAKE_CURRENT_LIST_DIR}/version-script-test.lds")
   CHECK_C_COMPILER_FLAG("" HAS_VERSION_SCRIPT_SUPPORT)
   SET(_HAS_VERSION_SCRIPT_SUPPORT ${HAS_VERSION_SCRIPT_SUPPORT} CACHE INTERNAL "Linker supports version scripts")
 ENDMACRO(_CHECK_VERSION_SCRIPT_SUPPORT)
diff --git a/cmake/version.cmake b/cmake/version.cmake
index 32f89f1..22d304f 100644
--- a/cmake/version.cmake
+++ b/cmake/version.cmake
@@ -239,7 +239,8 @@ MACRO(SPLIT_VERSION_NUMBER VERSION
     SET(${VERSION_PATCH_VAR} UNKNOWN)
   ELSE()
     # Extract the version from PROJECT_VERSION
-    string(REPLACE "." ";" _PROJECT_VERSION_LIST "${VERSION}")
+    string(REGEX REPLACE "-.*$" "" _PROJECT_VERSION_LIST "${VERSION}")
+    string(REPLACE "." ";" _PROJECT_VERSION_LIST "${_PROJECT_VERSION_LIST}")
     list(LENGTH _PROJECT_VERSION_LIST SIZE)
     IF(${SIZE} GREATER 0)
       list(GET _PROJECT_VERSION_LIST 0 ${VERSION_MAJOR_VAR})
@@ -248,9 +249,7 @@ MACRO(SPLIT_VERSION_NUMBER VERSION
       list(GET _PROJECT_VERSION_LIST 1 ${VERSION_MINOR_VAR})
     ENDIF()
     IF(${SIZE} GREATER 2)
-      string(REPLACE "-" ";" _PROJECT_VERSION_LIST "${_PROJECT_VERSION_LIST}")
       list(GET _PROJECT_VERSION_LIST 2 ${VERSION_PATCH_VAR})
     ENDIF()
   ENDIF()
 ENDMACRO()
-
