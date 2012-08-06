require 'formula'

class LogNinja < Formula
  homepage 'https://github.com/mrmanc/log-ninja'
  head 'git://github.com/mrmanc/log-ninja.git'

  def install
    bin.install 'distribution'
  end
end
