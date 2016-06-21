class XmiMsim < Formula
  homepage "https://github.com/tschoonj/xmimsim"
  url "http://lvserver.ugent.be/xmi-msim/xmimsim-5.0.tar.gz"
  mirror "https://xmi-msim.s3.amazonaws.com/xmimsim-5.0.tar.gz"
  sha256 "3503b56bb36ec555dc941b958308fde9f4e550ba3de4af3b6913bc29c2c0c9f1"
  revision 3

  bottle do
    sha256 "2802b089114e7c2b83385e927cee7d078b5cbac8792a91dd0ae27533b85a2fd2" => :yosemite
    sha256 "8c04f8cb8bc1d70c2b1dd780fff8c551d9f75bb21cada545bc6f710242fd5278" => :mavericks
  end

  depends_on :fortran
  depends_on "gsl"
  depends_on "fgsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "pkg-config" => :build
  depends_on "xraylib" => "with-fortran"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch do
    url "https://github.com/tschoonj/xmimsim/commit/682ff5b413fc326c1cc8e9931d34bce3e920c798.diff"
    sha256 "bf59bcf0091a8f5b4680ab99e3bd0609bcd6558d79c1b71e0473ecb1ec4d0123"
  end

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify",
                          "--enable-opencl"
    system "make"

    # this next step can take a long time...
    system "./bin/xmimsim-db"
    system "make", "install"
    (share / "xmimsim").install "xmimsimdata.h5"
  end

  test do
    system "#{bin}/xmimsim", "--version"
  end
end
