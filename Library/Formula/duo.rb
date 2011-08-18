require 'formula'

class Duo < Formula
  url 'https://github.com/downloads/duosecurity/duo_unix/duo_unix-1.7.tar.gz'
  homepage 'https://github.com/duosecurity/duo_unix'
  md5 '20ae128608dd2da7cb15f5724e7a8888'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make install"
    etc.install 'login_duo/login_duo.conf'
  end
end
