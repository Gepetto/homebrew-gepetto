class Omniorbpy < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
  sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"

  bottle do
    cellar :any
    root_url "https://github.com/Gepetto/omniORBpy/releases/download/v4.2.4"
    sha256 "35129cd8a0920dd0b82956b07c73fc12bbc20dabd72b8ce8623d7ce4df9e4e33" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb"
  depends_on "python@3.8"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    omniorb = Formula["omniorb"].opt_prefix
    
    ENV["PYTHON"] = "#{py_prefix}/bin/python#{pyver}"

    system "./configure", "--prefix=#{prefix}", "--with-omniorb=#{omniorb}"
    system "make", "install"
  end

  test do
    system false
  end
end
