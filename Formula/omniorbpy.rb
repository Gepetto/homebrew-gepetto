class Omniorbpy < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
  sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bae2f4422d81b381e9eb0ac25f0df932d766c57865329057a26fd8abd9da8d66" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb"
  depends_on "python@3.9"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py_prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    omniorb = Formula["omniorb"].opt_prefix
    
    ENV["PYTHON"] = "#{py_prefix}/bin/python#{pyver}"

    system "./configure", "--prefix=#{prefix}", "--with-omniorb=#{omniorb}"
    system "make", "install"
  end

  test do
    system false
  end
end
