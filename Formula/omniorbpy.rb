class Omniorbpy < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.3/omniORBpy-4.2.3.tar.bz2"
  sha256 "5c601888e57c7664324357a1be50f2739c468057b46fba29821a25069fc0aee5"

  bottle do
    cellar :any
    root_url "https://github.com/Gepetto/omniORBpy/releases/download/v4.2.3"
    sha256 "e3d01c03cad7edb7ec11dd199b91b23f9d9c38fcd19e35b294741c509ebf4200" => :mojave
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
