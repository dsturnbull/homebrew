require 'formula'

class Snort < Formula
  homepage 'http://www.snort.org'
  url 'http://www.snort.org/dl/snort-current/snort-2.9.3.1.tar.gz'
  sha1 '25dfea22a988dd1dc09a1716d8ebfcf2b7d61c19'

  depends_on 'daq'
  depends_on 'libdnet'
  depends_on 'pcre'

  option 'enable-debug', "Compile Snort with --enable-debug and --enable-debug-msgs"

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-ipv6
              --enable-gre
              --enable-mpls
              --enable-targetbased
              --enable-decoder-preprocessor-rules
              --enable-ppm
              --enable-perfprofiling
              --enable-zlib
              --enable-active-response
              --enable-normalizer
              --enable-reload
              --enable-react
              --enable-flexresp3]

    if build.include? 'enable-debug'
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end

  def patches; DATA; end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end

__END__
diff --git a/src/log_text.c b/src/log_text.c
index ce5a9b1..d2e054f 100644
--- a/src/log_text.c
+++ b/src/log_text.c
@@ -555,7 +555,12 @@ void LogIpAddrs(TextLog *log, Packet *p)
     }
     else
     {
-        char *ip_fmt = "%s:%d -> %s:%d";
+        char *ip_fmt;
+
+        if (IS_IP6(p))
+            ip_fmt = "[%s]:%d -> [%s]:%d";
+        else
+            ip_fmt = "%s:%d -> %s:%d";
 
         if (ScObfuscate())
         {
