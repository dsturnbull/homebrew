require 'formula'

class Libdaq < Formula
  url 'http://www.snort.org/downloads/860'
  homepage 'http://www.snort.org/'
  md5 'ea9d8147f39c44ce00dd2d7eb19ce0ea'
  version '0.5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
