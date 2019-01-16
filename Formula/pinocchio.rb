class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.0.0/pinocchio-2.0.0.tar.gz"
    sha256 "d26fa5fa4b25acbdfe83b686b73ccbc724a51c7532ccb8ce259b5c06d6b80525"
    
    patch :DATA
  end

  bottle do
  root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.0.0/pinocchio-2.0.0.mojave.bottle.tar.gz"
    sha256 "fc46d2dfd67a95b08dac2f2e616e7b87c52de14a7dbb9cfa5ff30352da7f7669" => :mojave
  end

  #head do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "master"
  #end

  #devel do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "devel"
  #end

  option "without-python", "Build without Python support"
  option "without-fcl", "Build without FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "fcl"

  def install
    if build.devel?
      system "git submodule update --init"
    end

    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
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
diff --git a/cmake/python.cmake b/cmake/python.cmake
index 75fafbf..15ef89b 100644
--- a/cmake/python.cmake
+++ b/cmake/python.cmake
@@ -1,4 +1,4 @@
-# Copyright (C) 2008-2014 LAAS-CNRS, JRL AIST-CNRS.
+# Copyright (C) 2008-2019 LAAS-CNRS, JRL AIST-CNRS, INRIA.
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -54,6 +54,8 @@ IF (NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)
 ENDIF (NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)
 MESSAGE(STATUS "PythonInterp: ${PYTHON_EXECUTABLE}")
 
+# Inform PythonLibs of the required version of PythonInterp
+SET(PYTHONLIBS_VERSION_STRING ${PYTHON_VERSION_STRING})
 FIND_PACKAGE(PythonLibs ${ARGN})
 MESSAGE(STATUS "PythonLibraries: ${PYTHON_LIBRARIES}")
 IF (NOT ${PYTHONLIBS_FOUND} STREQUAL TRUE)
