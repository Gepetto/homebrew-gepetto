class Omniorbpy < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.3/omniORBpy-4.2.3.tar.bz2"
  sha256 "5c601888e57c7664324357a1be50f2739c468057b46fba29821a25069fc0aee5"

  patch :DATA

  bottle do
    cellar :any
    root_url "https://github.com/Gepetto/omniORBpy/releases/download/v4.2.3"
    rebuild 1
    sha256 "55612da3b1f7d35da3a5a9b634541045152f80e5c52af7260fc8349e3743744a" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb"
  depends_on "python"

  def install
    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    omniorb = Formula["omniorb"].opt_prefix
    
    ENV["PYTHON"] = "#{py_prefix}/bin/python#{pyver}"

    system "./configure", "--prefix=#{prefix}", "--with-omniorb=#{omniorb}"
    system "make", "install"
  end

  test do
    system false
  end
end
__END__
diff a/python3/omniidl_be/python.py b/python3/omniidl_be/python.py
index ade8d11..e5515b6 100644
--- a/python3/omniidl_be/python.py
+++ b/python3/omniidl_be/python.py
@@ -2060,21 +2060,21 @@ class DocstringVisitor (idlvisitor.AstVisitor):
 
     def visitOperation(self, node):
         if node.identifier() == self.target_id:
-            sn = node.scopedName() + ["im_func"]
-            sn[-3] = "_objref_" + sn[-3]
+            sn = node.scopedName()
+            sn[-2] = "_objref_" + sn[-2]
             self.docs.append((sn, self.target_node.scopedName()))
             self.ok = 1
 
     def visitAttribute(self, node):
         for n in node.declarators():
             if n.identifier() == self.target_id:
-                sn = n.scopedName() + ["im_func"]
-                sn[-3] = "_objref_" + sn[-3]
-                sn[-2] = "_get_"    + sn[-2]
+                sn = n.scopedName()
+                sn[-2] = "_objref_" + sn[-2]
+                sn[-1] = "_get_"    + sn[-1]
                 self.docs.append((sn, self.target_node.scopedName()))
                 if not node.readonly():
                     sn = sn[:]
-                    sn[-2] = "_set_" + n.identifier()
+                    sn[-1] = "_set_" + n.identifier()
                     self.docs.append((sn, self.target_node.scopedName()))
                 self.ok = 1
