require 'formula'

class Oinkmaster < Formula
  url 'http://downloads.sourceforge.net/project/oinkmaster/oinkmaster/2.0/oinkmaster-2.0.tar.gz'
  homepage 'http://oinkmaster.sourceforge.net/'
  md5 'd2a1b56f51cf40e919c63206ca4ec8f8'
  depends_on 'snort'

  def install
    system "mkdir #{prefix}/bin"
    system "mkdir #{prefix}/etc"
    system "mkdir #{prefix}/share"
    system "mkdir #{prefix}/share/snort"
    system "touch #{prefix}/share/snort/.keepme"

    system "cp oinkmaster.pl #{prefix}/bin"
    system "cp oinkmaster.conf #{prefix}/etc"
  end
end
