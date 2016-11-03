class HppFcl < Formula
  desc "An extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "ftp://trac.laas.fr/pub/openrobots/hpp-fcl/hpp-fcl-0.4.2.tar.gz"
  sha256 "d1ef1eba5cd983b7e1efbff136aeadc23ebdf87eb736d6ed12702d7d7e168f46"

  head "https://github.com/humanoid-path-planner/hpp-fcl", :branch => "master"

  patch :p1, :DATA

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "homebrew/science/libccd"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

__END__
