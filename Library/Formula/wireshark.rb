require 'formula'

class Wireshark < Formula
  homepage 'http://www.wireshark.org'
  url 'http://www.wireshark.org/download/src/all-versions/wireshark-1.8.5.tar.bz2'
  sha1 '76c719d92a2e200588a5452bbe61178b915eb99b'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls2' => :optional
  depends_on 'libgcrypt' => :optional
  depends_on 'c-ares' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'

  if build.include? 'with-x'
    depends_on :x11
    depends_on 'gtk+'
  end

  option 'with-x', 'Include X11 support'
  option 'with-python', 'Enable experimental Python bindings'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Optionally enable experimental python bindings; is known to cause
    # some runtime issues, e.g.
    # "dlsym(0x8fe467fc, py_create_dissector_handle): symbol not found"
    args << '--without-python' unless build.include? 'with-python'

    # actually just disables the GTK GUI
    args << '--disable-wireshark' unless build.include? 'with-x'

    system "./configure", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end
end

__END__
diff --git a/print.c b/print.c
index 6b6faad..6b21ad9 100644
--- a/print.c
+++ b/print.c
@@ -166,6 +166,7 @@ void proto_tree_print_node(proto_node *node, gpointer data)
 	const guint8	*pd;
 	gchar		label_str[ITEM_LABEL_LENGTH];
 	gchar		*label_ptr;
+	gchar		*dfilter_string;
 
 	g_assert(fi && "dissection with an invisible proto tree?");
 
@@ -177,13 +178,26 @@ void proto_tree_print_node(proto_node *node, gpointer data)
 	if (!pdata->success)
 		return;
 
+    label_ptr = proto_construct_match_selected_string(fi, pdata->edt);
+
 	/* was a free format label produced? */
-	if (fi->rep) {
-		label_ptr = fi->rep->representation;
-	}
-	else { /* no, make a generic label */
-		label_ptr = label_str;
-		proto_item_fill_label(fi, label_str);
+	// if (fi->rep) {
+	// 	label_ptr = fi->rep->representation;
+	// }
+	// else { /* no, make a generic label */
+	// 	label_ptr = label_str;
+	// 	proto_item_fill_label(fi, label_str);
+	// }
+
+
+	if (!label_ptr) {
+		/* was a free format label produced? */
+		if (fi->rep) {
+			label_ptr = fi->rep->representation;
+		} else { /* no, make a generic label */
+			label_ptr = label_str;
+			proto_item_fill_label(fi, label_str);
+		}
 	}
 
 	if (PROTO_ITEM_IS_GENERATED(node)) {
diff --git a/tshark.c b/tshark.c
index ccdd80e..4cd038f 100644
--- a/tshark.c
+++ b/tshark.c
@@ -2620,7 +2620,7 @@ process_packet_second_pass(capture_file *cf, frame_data *fdata,
 
          2) we're printing packet info but we're *not* verbose; in verbose
             mode, we print the protocol tree, not the protocol summary. */
-    if ((tap_flags & TL_REQUIRES_COLUMNS) || (print_packet_info && !verbose))
+    if ((tap_flags & TL_REQUIRES_COLUMNS) || (print_packet_info))
       cinfo = &cf->cinfo;
     else
       cinfo = NULL;
@@ -3074,7 +3074,7 @@ process_packet(capture_file *cf, gint64 offset, const struct wtap_pkthdr *whdr,
 
          2) we're printing packet info but we're *not* verbose; in verbose
             mode, we print the protocol tree, not the protocol summary. */
-    if ((tap_flags & TL_REQUIRES_COLUMNS) || (print_packet_info && !verbose))
+    if ((tap_flags & TL_REQUIRES_COLUMNS) || (print_packet_info))
       cinfo = &cf->cinfo;
     else
       cinfo = NULL;
@@ -3439,6 +3439,11 @@ print_packet(capture_file *cf, epan_dissect_t *edt)
       print_args.print_formfeed = FALSE;
       packet_range_init(&print_args.range);
       */
+
+      printf("packet ");
+      epan_dissect_fill_in_columns(edt, FALSE, TRUE);
+      print_columns(cf);
+
       print_args.print_hex = verbose && print_hex;
       print_args.print_dissections = verbose ? print_dissections_expanded : print_dissections_none;
 
