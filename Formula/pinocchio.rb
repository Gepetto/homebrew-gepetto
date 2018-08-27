class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v1.3.0/pinocchio-1.3.0.tar.gz"
    sha256 "6e82eba895581c7ecf287f35a4c927c9916a71695ce7862f9ed6a0974768923e"
    
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v1.3.0"

    sha256 "d2992129cb9b5cf3770421d9baecbca4dbfb84be34602869a3ecf9d2fa569bd8" => :high_sierra
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
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_UNIT_TESTS=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

__END__
diff --git a/src/multibody/liegroup/liegroup-variant-visitors.hxx b/src/multibody/liegroup/liegroup-variant-visitors.hxx
index 487ace36..d5562309 100644
--- a/src/multibody/liegroup/liegroup-variant-visitors.hxx
+++ b/src/multibody/liegroup/liegroup-variant-visitors.hxx
@@ -118,24 +118,23 @@ namespace se3
   template <class ConfigIn_t, class Tangent_t, class ConfigOut_t>
   struct LieGroupIntegrateVisitor : visitor::LieGroupVisitorBase< LieGroupIntegrateVisitor<ConfigIn_t,Tangent_t,ConfigOut_t> >
   {
-    typedef boost::fusion::vector<const Eigen::MatrixBase<ConfigIn_t> &,
-                                  const Eigen::MatrixBase<Tangent_t> &,
-                                  const Eigen::MatrixBase<ConfigOut_t> &> ArgsType;
-    
+    typedef boost::fusion::vector<const ConfigIn_t &,
+                                  const Tangent_t &,
+                                  ConfigOut_t &> ArgsType;
+
     LIE_GROUP_VISITOR(LieGroupIntegrateVisitor);
-    
-    template<typename D>
-    static void algo(const LieGroupBase<D> & lg,
+
+    template<typename LieGroupDerived>
+    static void algo(const LieGroupBase<LieGroupDerived> & lg,
                      const Eigen::MatrixBase<ConfigIn_t> & q,
                      const Eigen::MatrixBase<Tangent_t>  & v,
                      const Eigen::MatrixBase<ConfigOut_t>& qout)
     {
       ConfigOut_t & qout_ = const_cast< ConfigOut_t& >(qout.derived());
-      lg.integrate(Eigen::Ref<const typename D::ConfigVector_t>(q),
-                   Eigen::Ref<const typename D::TangentVector_t>(v),
-                   Eigen::Ref<typename D::ConfigVector_t>(qout_));
+      lg.integrate(Eigen::Ref<const typename LieGroupDerived::ConfigVector_t>(q),
+                   Eigen::Ref<const typename LieGroupDerived::TangentVector_t>(v),
+                   Eigen::Ref<typename LieGroupDerived::ConfigVector_t>(qout_));
     }
-    
   };
   
   template <class ConfigIn_t, class Tangent_t, class ConfigOut_t>
@@ -144,13 +143,17 @@ namespace se3
                         const Eigen::MatrixBase<Tangent_t>  & v,
                         const Eigen::MatrixBase<ConfigOut_t>& qout)
   {
+    EIGEN_STATIC_ASSERT_VECTOR_ONLY(ConfigIn_t)
+    EIGEN_STATIC_ASSERT_VECTOR_ONLY(Tangent_t)
+    EIGEN_STATIC_ASSERT_VECTOR_ONLY(ConfigOut_t)
+    
     typedef LieGroupIntegrateVisitor<ConfigIn_t,Tangent_t,ConfigOut_t> Operation;
     assert(q.size() == nq(lg));
     assert(v.size() == nv(lg));
     assert(qout.size() == nq(lg));
     
     ConfigOut_t & qout_ = const_cast< ConfigOut_t& >(qout.derived());
-    Operation::run(lg,typename Operation::ArgsType(q,v,qout_));
+    Operation::run(lg,typename Operation::ArgsType(q.derived(),v.derived(),qout_.derived()));
   }
 }
 
diff --git a/unittest/liegroups.cpp b/unittest/liegroups.cpp
index 2d0af952..3a40891e 100644
--- a/unittest/liegroups.cpp
+++ b/unittest/liegroups.cpp
@@ -460,10 +460,13 @@ struct TestLieGroupVariantVisitor
     
     ConfigVector_t q0 = lg.random();
     TangentVector_t v = TangentVector_t::Random(lg.nv());
-    ConfigVector_t qout(lg.nq()), qout_ref(lg.nq());
+    ConfigVector_t qout_ref(lg.nq());
     lg.integrate(q0, v, qout_ref);
     
-    integrate(lg_variant, q0, v, qout);
+    typedef Eigen::VectorXd ConfigVectorGeneric;
+    typedef Eigen::VectorXd TangentVectorGeneric;
+    ConfigVectorGeneric qout(lg.nq());
+    integrate(lg_variant, ConfigVectorGeneric(q0), TangentVectorGeneric(v), qout);
     BOOST_CHECK(qout.isApprox(qout_ref));
   }
 };
