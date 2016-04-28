/* gdk-pixbuf-2.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Gdk", gir_namespace = "GdkPixbuf", gir_version = "2.0", lower_case_cprefix = "gdk_")]
namespace Gdk {
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h")]
	public class Pixbuf : GLib.Object, GLib.Icon, GLib.LoadableIcon {
		[CCode (has_construct_function = false)]
		public Pixbuf (Gdk.Colorspace colorspace, bool has_alpha, int bits_per_sample, int width, int height);
		public Gdk.Pixbuf add_alpha (bool substitute_color, uint8 r, uint8 g, uint8 b);
		[Version (since = "2.12")]
		public Gdk.Pixbuf apply_embedded_orientation ();
		public void composite (Gdk.Pixbuf dest, int dest_x, int dest_y, int dest_width, int dest_height, double offset_x, double offset_y, double scale_x, double scale_y, Gdk.InterpType interp_type, int overall_alpha);
		public void composite_color (Gdk.Pixbuf dest, int dest_x, int dest_y, int dest_width, int dest_height, double offset_x, double offset_y, double scale_x, double scale_y, Gdk.InterpType interp_type, int overall_alpha, int check_x, int check_y, int check_size, uint32 color1, uint32 color2);
		public Gdk.Pixbuf composite_color_simple (int dest_width, int dest_height, Gdk.InterpType interp_type, int overall_alpha, int check_size, uint32 color1, uint32 color2);
		public Gdk.Pixbuf copy ();
		public void copy_area (int src_x, int src_y, int width, int height, Gdk.Pixbuf dest_pixbuf, int dest_x, int dest_y);
		public void fill (uint32 pixel);
		[Version (since = "2.6")]
		public Gdk.Pixbuf? flip (bool horizontal);
		[CCode (has_construct_function = false)]
		[Version (since = "2.32")]
		public Pixbuf.from_bytes (GLib.Bytes data, Gdk.Colorspace colorspace, bool has_alpha, int bits_per_sample, int width, int height, int rowstride);
		[CCode (has_construct_function = false)]
		public Pixbuf.from_data ([CCode (array_length = false)] owned uint8[] data, Gdk.Colorspace colorspace, bool has_alpha, int bits_per_sample, int width, int height, int rowstride, [CCode (type = "GdkPixbufDestroyNotify")] Gdk.PixbufDestroyNotify? destroy_fn = GLib.free);
		[CCode (has_construct_function = false)]
		public Pixbuf.from_file (string filename) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.6")]
		public Pixbuf.from_file_at_scale (string filename, int width, int height, bool preserve_aspect_ratio) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.4")]
		public Pixbuf.from_file_at_size (string filename, int width, int height) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (deprecated = true, deprecated_since = "2.32")]
		public Pixbuf.from_inline ([CCode (array_length_cname = "data_length", array_length_pos = 0.5)] uint8[] data, bool copy_pixels = true) throws GLib.Error;
		[CCode (cheader_filename = "gdk-pixbuf/gdk-pixdata.h")]
		[Version (deprecated = true, deprecated_since = "2.32")]
		public static Gdk.Pixbuf from_pixdata (Gdk.Pixdata pixdata, bool copy_pixels = true) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.26")]
		public Pixbuf.from_resource (string resource_path) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.26")]
		public Pixbuf.from_resource_at_scale (string resource_path, int width, int height, bool preserve_aspect_ratio) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.14")]
		public Pixbuf.from_stream (GLib.InputStream stream, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[CCode (cname = "gdk_pixbuf_new_from_stream_async", has_construct_function = false)]
		[Version (since = "2.24")]
		public async Pixbuf.from_stream_async (GLib.InputStream stream, GLib.Cancellable? cancellable) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.14")]
		public Pixbuf.from_stream_at_scale (GLib.InputStream stream, int width, int height, bool preserve_aspect_ratio, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[CCode (cname = "gdk_pixbuf_new_from_stream_at_scale_async", finish_name = "gdk_pixbuf_new_from_stream_finish")]
		public async Pixbuf.from_stream_at_scale_async (GLib.InputStream stream, int width, int height, bool preserve_aspect_ratio, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[CCode (has_construct_function = false)]
		public Pixbuf.from_xpm_data ([CCode (array_length = false, array_null_terminated = true)] string[] data);
		public int get_bits_per_sample ();
		[Version (since = "2.26")]
		public size_t get_byte_length ();
		public Gdk.Colorspace get_colorspace ();
		[Version (since = "2.4")]
		public static unowned Gdk.PixbufFormat? get_file_info (string filename, out int width, out int height);
		[Version (since = "2.32")]
		public static async unowned Gdk.PixbufFormat get_file_info_async (string filename, GLib.Cancellable? cancellable, out int width, out int height) throws GLib.Error;
		[Version (since = "2.2")]
		public static GLib.SList<weak Gdk.PixbufFormat> get_formats ();
		public bool get_has_alpha ();
		public int get_height ();
		public int get_n_channels ();
		public unowned string get_option (string key);
		[Version (since = "2.32")]
		public GLib.HashTable<weak string,weak string> get_options ();
		[CCode (array_length = false)]
		public unowned uint8[] get_pixels ();
		[CCode (array_length_pos = 0.1, array_length_type = "guint")]
		[Version (since = "2.26")]
		public unowned uint8[] get_pixels_with_length ();
		public int get_rowstride ();
		public int get_width ();
		[CCode (cname = "gdk_pixbuf_new_from_stream_async", finish_name = "gdk_pixbuf_new_from_stream_finish")]
		[Version (deprecated_since = "vala-0.18", replacement = "Pixbuf.from_stream_async")]
		public static async Gdk.Pixbuf new_from_stream_async (GLib.InputStream stream, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[CCode (cname = "gdk_pixbuf_new_from_stream_at_scale_async", finish_name = "gdk_pixbuf_new_from_stream_finish")]
		[Version (deprecated_since = "vala-0.18", replacement = "Pixbuf.from_stream_at_scale_async")]
		public static async Gdk.Pixbuf new_from_stream_at_scale_async (GLib.InputStream stream, int width, int height, bool preserve_aspect_ratio, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[Version (since = "2.32")]
		public GLib.Bytes read_pixel_bytes ();
		[Version (since = "2.32")]
		public uint8 read_pixels ();
		[Version (since = "2.6")]
		public Gdk.Pixbuf? rotate_simple (Gdk.PixbufRotation angle);
		public void saturate_and_pixelate (Gdk.Pixbuf dest, float saturation, bool pixelate);
		public bool save (string filename, string type, ...) throws GLib.Error;
		public bool save_to_buffer ([CCode (array_length_type = "gsize", type = "gchar**")] out uint8[] buffer, string type, ...) throws GLib.Error;
		[Version (since = "2.4")]
		public bool save_to_bufferv ([CCode (array_length_cname = "buffer_size", array_length_pos = 1.5, array_length_type = "gsize")] out uint8[] buffer, string type, [CCode (array_length = false, array_null_terminated = true)] string[] option_keys, [CCode (array_length = false, array_null_terminated = true)] string[] option_values) throws GLib.Error;
		public bool save_to_callback (Gdk.PixbufSaveFunc save_func, string type, ...) throws GLib.Error;
		[Version (since = "2.4")]
		public bool save_to_callbackv ([CCode (delegate_target_pos = 1.5)] Gdk.PixbufSaveFunc save_func, string type, [CCode (array_length = false, array_null_terminated = true)] string[] option_keys, [CCode (array_length = false, array_null_terminated = true)] string[] option_values) throws GLib.Error;
		public bool save_to_stream (GLib.OutputStream stream, string type, GLib.Cancellable? cancellable = null, ...) throws GLib.Error;
		[CCode (finish_name = "gdk_pixbuf_save_to_stream_finish")]
		public async bool save_to_stream_async (GLib.OutputStream stream, string type, GLib.Cancellable? cancellable = null, ...) throws GLib.Error;
		[Version (since = "2.36")]
		public bool save_to_streamv (GLib.OutputStream stream, string type, [CCode (array_length = false, array_null_terminated = true)] string[] option_keys, [CCode (array_length = false, array_null_terminated = true)] string[] option_values, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[Version (since = "2.36")]
		public async void save_to_streamv_async (GLib.OutputStream stream, string type, [CCode (array_length = false, array_null_terminated = true)] string[] option_keys, [CCode (array_length = false, array_null_terminated = true)] string[] option_values, GLib.Cancellable? cancellable);
		public bool savev (string filename, string type, [CCode (array_length = false, array_null_terminated = true)] string[] option_keys, [CCode (array_length = false, array_null_terminated = true)] string[] option_values) throws GLib.Error;
		public void scale (Gdk.Pixbuf dest, int dest_x, int dest_y, int dest_width, int dest_height, double offset_x, double offset_y, double scale_x, double scale_y, Gdk.InterpType interp_type);
		public Gdk.Pixbuf scale_simple (int dest_width, int dest_height, Gdk.InterpType interp_type);
		[CCode (has_construct_function = false)]
		public Pixbuf.subpixbuf (Gdk.Pixbuf src_pixbuf, int src_x, int src_y, int width, int height);
		[CCode (cname = "gdk_pixbuf_new_from_data", has_construct_function = false)]
		public Pixbuf.with_unowned_data ([CCode (array_length = false)] uint8[] data, Gdk.Colorspace colorspace, bool has_alpha, int bits_per_sample, int width, int height, int rowstride, [CCode (type = "GdkPixbufDestroyNotify")] Gdk.PixbufDestroyNotify? destroy_fn = null);
		public int bits_per_sample { get; construct; }
		public Gdk.Colorspace colorspace { get; construct; }
		public bool has_alpha { get; construct; }
		public int height { get; construct; }
		public int n_channels { get; construct; }
		[NoAccessorMethod]
		public GLib.Bytes pixel_bytes { owned get; construct; }
		public void* pixels { get; construct; }
		public int rowstride { get; construct; }
		public int width { get; construct; }
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", type_id = "gdk_pixbuf_animation_get_type ()")]
	public class PixbufAnimation : GLib.Object {
		[CCode (has_construct_function = false)]
		protected PixbufAnimation ();
		[CCode (has_construct_function = false)]
		public PixbufAnimation.from_file (string filename) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.28")]
		public PixbufAnimation.from_resource (string resource_path) throws GLib.Error;
		[CCode (has_construct_function = false)]
		[Version (since = "2.28")]
		public PixbufAnimation.from_stream (GLib.InputStream stream, GLib.Cancellable? cancellable = null) throws GLib.Error;
		[CCode (cname = "gdk_pixbuf_animation_new_from_stream_async", has_construct_function = false)]
		[Version (since = "2.28")]
		public async PixbufAnimation.from_stream_async (GLib.InputStream stream, GLib.Cancellable? cancellable) throws GLib.Error;
		public int get_height ();
		public Gdk.PixbufAnimationIter get_iter (GLib.TimeVal? start_time);
		public unowned Gdk.Pixbuf get_static_image ();
		public int get_width ();
		public bool is_static_image ();
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", type_id = "gdk_pixbuf_animation_iter_get_type ()")]
	public class PixbufAnimationIter : GLib.Object {
		[CCode (has_construct_function = false)]
		protected PixbufAnimationIter ();
		public bool advance (GLib.TimeVal? current_time);
		public int get_delay_time ();
		public unowned Gdk.Pixbuf get_pixbuf ();
		public bool on_currently_loading_frame ();
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", copy_function = "g_boxed_copy", free_function = "g_boxed_free", type_id = "gdk_pixbuf_format_get_type ()")]
	[Compact]
	public class PixbufFormat {
		[Version (since = "2.22")]
		public Gdk.PixbufFormat copy ();
		[Version (since = "2.22")]
		public void free ();
		[Version (since = "2.2")]
		public string get_description ();
		[CCode (array_length = false, array_null_terminated = true)]
		[Version (since = "2.2")]
		public string[] get_extensions ();
		[Version (since = "2.6")]
		public string get_license ();
		[CCode (array_length = false, array_null_terminated = true)]
		[Version (since = "2.2")]
		public string[] get_mime_types ();
		[Version (since = "2.2")]
		public string get_name ();
		[Version (since = "2.6")]
		public bool is_disabled ();
		[Version (since = "2.6")]
		public bool is_scalable ();
		[Version (since = "2.2")]
		public bool is_writable ();
		[Version (since = "2.6")]
		public void set_disabled (bool disabled);
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", type_id = "gdk_pixbuf_loader_get_type ()")]
	public class PixbufLoader : GLib.Object {
		[CCode (has_construct_function = false)]
		public PixbufLoader ();
		public bool close () throws GLib.Error;
		public unowned Gdk.PixbufAnimation get_animation ();
		[Version (since = "2.2")]
		public unowned Gdk.PixbufFormat? get_format ();
		public unowned Gdk.Pixbuf get_pixbuf ();
		[Version (since = "2.2")]
		public void set_size (int width, int height);
		[CCode (has_construct_function = false)]
		[Version (since = "2.4")]
		public PixbufLoader.with_mime_type (string mime_type) throws GLib.Error;
		[CCode (has_construct_function = false)]
		public PixbufLoader.with_type (string image_type) throws GLib.Error;
		public bool write ([CCode (array_length_cname = "count", array_length_pos = 1.1, array_length_type = "gsize")] uint8[] buf) throws GLib.Error;
		[Version (since = "2.30")]
		public bool write_bytes (GLib.Bytes buffer) throws GLib.Error;
		public virtual signal void area_prepared ();
		public virtual signal void area_updated (int x, int y, int width, int height);
		public virtual signal void closed ();
		public virtual signal void size_prepared (int width, int height);
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", type_id = "gdk_pixbuf_simple_anim_get_type ()")]
	public class PixbufSimpleAnim : Gdk.PixbufAnimation {
		[CCode (has_construct_function = false)]
		[Version (since = "2.8")]
		public PixbufSimpleAnim (int width, int height, float rate);
		[Version (since = "2.8")]
		public void add_frame (Gdk.Pixbuf pixbuf);
		[Version (since = "2.18")]
		public bool get_loop ();
		[Version (since = "2.18")]
		public void set_loop (bool loop);
		[Version (since = "2.18")]
		public bool loop { get; set; }
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", type_id = "gdk_pixbuf_simple_anim_iter_get_type ()")]
	public class PixbufSimpleAnimIter : Gdk.PixbufAnimationIter {
		[CCode (has_construct_function = false)]
		protected PixbufSimpleAnimIter ();
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixdata.h", has_type_id = false)]
	public struct Pixdata {
		public uint32 magic;
		public int32 length;
		public uint32 pixdata_type;
		public uint32 rowstride;
		public uint32 width;
		public uint32 height;
		[CCode (array_length = false, array_null_terminated = true)]
		public weak uint8[] pixel_data;
		[Version (deprecated = true, deprecated_since = "2.32")]
		public bool deserialize ([CCode (array_length_cname = "stream_length", array_length_pos = 0.5, array_length_type = "guint")] uint8[] stream) throws GLib.Error;
		[CCode (array_length_pos = 0.1, array_length_type = "guint")]
		[Version (deprecated = true, deprecated_since = "2.32")]
		public uint8[] serialize ();
		[Version (deprecated = true, deprecated_since = "2.32")]
		public GLib.StringBuilder to_csource (string name, Gdk.PixdataDumpType dump_type);
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cprefix = "GDK_COLORSPACE_", type_id = "gdk_colorspace_get_type ()")]
	public enum Colorspace {
		RGB
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cprefix = "GDK_INTERP_", type_id = "gdk_interp_type_get_type ()")]
	public enum InterpType {
		NEAREST,
		TILES,
		BILINEAR,
		HYPER
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cprefix = "GDK_PIXBUF_ALPHA_", type_id = "gdk_pixbuf_alpha_mode_get_type ()")]
	public enum PixbufAlphaMode {
		BILEVEL,
		FULL
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cprefix = "GDK_PIXBUF_ROTATE_", type_id = "gdk_pixbuf_rotation_get_type ()")]
	public enum PixbufRotation {
		NONE,
		COUNTERCLOCKWISE,
		UPSIDEDOWN,
		CLOCKWISE
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixdata.h", cprefix = "GDK_PIXDATA_DUMP_", has_type_id = false)]
	[Flags]
	public enum PixdataDumpType {
		PIXDATA_STREAM,
		PIXDATA_STRUCT,
		MACROS,
		GTYPES,
		CTYPES,
		STATIC,
		CONST,
		RLE_DECODER
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixdata.h", cprefix = "GDK_PIXDATA_", has_type_id = false)]
	[Flags]
	public enum PixdataType {
		COLOR_TYPE_RGB,
		COLOR_TYPE_RGBA,
		COLOR_TYPE_MASK,
		SAMPLE_WIDTH_8,
		SAMPLE_WIDTH_MASK,
		ENCODING_RAW,
		ENCODING_RLE,
		ENCODING_MASK
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cprefix = "GDK_PIXBUF_ERROR_")]
	public errordomain PixbufError {
		CORRUPT_IMAGE,
		INSUFFICIENT_MEMORY,
		BAD_OPTION,
		UNKNOWN_TYPE,
		UNSUPPORTED_OPERATION,
		FAILED,
		INCOMPLETE_ANIMATION;
		public static GLib.Quark quark ();
	}
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", instance_pos = 1.9)]
	public delegate void PixbufDestroyNotify ([CCode (array_length = false)] uint8[] pixels);
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixdata.h", instance_pos = -0.9)]
	public delegate bool PixbufSaveFunc ([CCode (array_length_type = "gsize")] uint8[] buf) throws GLib.Error;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_FEATURES_H")]
	public const int PIXBUF_FEATURES_H;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_MAGIC_NUMBER")]
	public const int PIXBUF_MAGIC_NUMBER;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_MAJOR")]
	public const int PIXBUF_MAJOR;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_MICRO")]
	public const int PIXBUF_MICRO;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_MINOR")]
	public const int PIXBUF_MINOR;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXBUF_VERSION")]
	public const string PIXBUF_VERSION;
	[CCode (cheader_filename = "gdk-pixbuf/gdk-pixbuf.h", cname = "GDK_PIXDATA_HEADER_LENGTH")]
	public const int PIXDATA_HEADER_LENGTH;
}
