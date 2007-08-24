[CCode (cprefix = "Gnome", lower_case_cprefix = "gnome_")]
namespace Gnome {
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_ERROR_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemError {
		NO_FILENAME,
		UNKNOWN_ENCODING,
		CANNOT_OPEN,
		NO_EXEC_STRING,
		BAD_EXEC_STRING,
		NO_URL,
		NOT_LAUNCHABLE,
		INVALID_TYPE,
	}
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_ICON_NO_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemIconFlags {
		KDE,
	}
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_LAUNCH_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemLaunchFlags {
		ONLY_ONE,
		USE_CURRENT_DIR,
		APPEND_URIS,
		APPEND_PATHS,
		DO_NOT_REAP_CHILD,
	}
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_LOAD_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemLoadFlags {
		ONLY_IF_EXISTS,
		NO_TRANSLATIONS,
	}
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemStatus {
		UNCHANGED,
		CHANGED,
		DISAPPEARED,
	}
	[CCode (cprefix = "GNOME_DESKTOP_ITEM_TYPE_", cheader_filename = "libgnome/gnome-desktop-item.h")]
	public enum DesktopItemType {
		NULL,
		APPLICATION,
		LINK,
		FSDEVICE,
		MIME_TYPE,
		DIRECTORY,
		SERVICE,
		SERVICE_TYPE,
	}
	[CCode (cheader_filename = "libgnomeui/gnome-ditem-edit.h")]
	public class DItemEdit : Gtk.Notebook {
		public signal void changed ();
		public signal void icon_changed ();
		public signal void name_changed ();
	}
	[CCode (cheader_filename = "libgnomeui/gnome-hint.h")]
	public class Hint : Gtk.Dialog {
	}
	[ReferenceType (dup_function = "gnome_desktop_item_ref", free_function = "gnome_desktop_item_unref")]
	[CCode (cheader_filename = "libgnome/gnome-desktop-item.h")]
	public struct DesktopItem {
		public bool attr_exists (string attr);
		public void clear_localestring (string attr);
		public void clear_section (string section);
		public weak Gnome.DesktopItem copy ();
		public int drop_uri_list (string uri_list, Gnome.DesktopItemLaunchFlags flags, GLib.Error error);
		[NoArrayLength]
		public int drop_uri_list_with_env (string uri_list, Gnome.DesktopItemLaunchFlags flags, string[] envp, GLib.Error error);
		public static GLib.Quark error_quark ();
		public bool exists ();
		public static weak string find_icon (Gtk.IconTheme icon_theme, string icon, int desired_size, int flags);
		public weak string get_attr_locale (string attr);
		public bool get_boolean (string attr);
		public Gnome.DesktopItemType get_entry_type ();
		public Gnome.DesktopItemStatus get_file_status ();
		public weak string get_icon (Gtk.IconTheme icon_theme);
		public weak GLib.List get_languages (string attr);
		public weak string get_localestring (string attr);
		public weak string get_localestring_lang (string attr, string language);
		public weak string get_location ();
		public weak string get_string (string attr);
		public weak string get_strings (string attr);
		public static GLib.Type get_type ();
		public int launch (GLib.List file_list, Gnome.DesktopItemLaunchFlags flags, GLib.Error error);
		public int launch_on_screen (GLib.List file_list, Gnome.DesktopItemLaunchFlags flags, Gdk.Screen screen, int workspace, GLib.Error error);
		[NoArrayLength]
		public int launch_with_env (GLib.List file_list, Gnome.DesktopItemLaunchFlags flags, string[] envp, GLib.Error error);
		public DesktopItem ();
		public DesktopItem.from_basename (string basename, Gnome.DesktopItemLoadFlags flags, GLib.Error error);
		public DesktopItem.from_file (string file, Gnome.DesktopItemLoadFlags flags, GLib.Error error);
		public DesktopItem.from_string (string uri, string string, long length, Gnome.DesktopItemLoadFlags flags, GLib.Error error);
		public DesktopItem.from_uri (string uri, Gnome.DesktopItemLoadFlags flags, GLib.Error error);
		public bool save (string under, bool force, GLib.Error error);
		public void set_boolean (string attr, bool value);
		public void set_entry_type (Gnome.DesktopItemType type);
		public void set_launch_time (uint timestamp);
		public void set_localestring (string attr, string value);
		public void set_localestring_lang (string attr, string language, string value);
		public void set_location (string location);
		public void set_location_file (string file);
		public void set_string (string attr, string value);
		[NoArrayLength]
		public void set_strings (string attr, string[] strings);
	}
}
