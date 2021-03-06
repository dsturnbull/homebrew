require 'formula'

class Xplanet < Formula
  homepage 'http://xplanet.sourceforge.net/'
  url 'http://sourceforge.net/projects/xplanet/files/xplanet/1.3.0/xplanet-1.3.0.tar.gz'
  sha1 '7c5208b501b441a0184cbb334a5658d0309d7dac'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'
  depends_on :x11

  def options
    [['--with-x', "Build for X11 instead of Aqua."]]
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if ARGV.include? "--with-x"
      args << "--with-x"
    else
      args << "--with-aqua" << "--without-x"
    end

    system "./configure", *args
    system "make install"
  end
end
