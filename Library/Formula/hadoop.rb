require 'formula'

class Hadoop < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-0.20.204.0/hadoop-0.20.204.0.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 'ea9a0699405074f169dccd3cc6adb608'

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $@
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib webapps contrib]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    inreplace "#{libexec}/conf/hadoop-env.sh",
      "# export JAVA_HOME=/usr/lib/j2sdk1.6-sun",
      "export JAVA_HOME=$(/usr/libexec/java_home)"
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/conf/hadoop-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
