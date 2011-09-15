require 'formula'

class DuoUnix < Formula
  homepage 'https://github.com/dsturnbull/duo_unix'
  head 'git://github.com/dsturnbull/duo_unix.git'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make install"
    etc.install 'login_duo/login_duo.conf'
  end
end
