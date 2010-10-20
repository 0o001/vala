/* gtk+-2.0.vala
 *
 * Copyright (C) 2008  Jared Moore
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jared Moore  <jaredm@gmx.com>
 */

namespace GLib {
	[Compact]
	[CCode (cname = "GIOExtension")]
	public class IOExtension {
		public extern Type get_type ();
	}

	[CCode (cname = "GFile")]
	public interface File : Object {
		[CCode (vfunc_name = "monitor_dir")]
		public abstract GLib.FileMonitor monitor_directory (GLib.FileMonitorFlags flags, GLib.Cancellable? cancellable = null) throws GLib.IOError;
		public abstract GLib.FileMonitor monitor_file (GLib.FileMonitorFlags flags, GLib.Cancellable? cancellable = null) throws GLib.IOError;
	}

	[Compact]
	[CCode (cname = "GSource", ref_function = "g_source_ref", unref_function = "g_source_unref")]
	public class SocketSource : GLib.Source {
		[CCode (cname = "g_source_set_callback")]
		public void set_callback ([CCode (type = "GSourceFunc")] owned SocketSourceFunc func);
	}

	[CCode (cname = "g_file_hash", cheader_filename = "gio/gio.h")]
	public static GLib.HashFunc file_hash;
	[CCode (cname = "g_file_equal", cheader_filename = "gio/gio.h")]
	public static GLib.EqualFunc file_equal;

	[CCode (cname = "GApplication")]
	public class Application {
		[CCode (cname = "g_application_quit_with_data")]
		public bool quit (GLib.Variant? platform_data = null);
	}

	[CCode (cheader_filename = "gio/gio.h")]
	namespace Bus {
		public async GLib.DBusConnection get (GLib.BusType bus_type, GLib.Cancellable? cancellable = null) throws GLib.IOError;
		public GLib.DBusConnection get_sync (GLib.BusType bus_type, GLib.Cancellable? cancellable = null) throws GLib.IOError;
		public T get_proxy_sync<T> (GLib.BusType bus_type, string name, string object_path, GLib.DBusProxyFlags flags = 0, GLib.Cancellable? cancellable = null) throws GLib.IOError;
		[CCode (cname = "g_bus_own_name_with_closures")]
		public uint own_name (GLib.BusType bus_type, string name, GLib.BusNameOwnerFlags flags, [CCode (type = "GClosure*")] owned GLib.BusAcquiredCallback bus_acquired_handler, [CCode (type = "GClosure*")] owned GLib.BusNameAcquiredCallback name_acquired_handler, [CCode (type = "GClosure*")] owned GLib.BusNameLostCallback name_lost_handler);
		[CCode (cname = "g_bus_own_name_on_connection_with_closures")]
		public uint own_name_on_connection (GLib.DBusConnection connection, string name, GLib.BusNameOwnerFlags flags, [CCode (type = "GClosure*")] owned GLib.BusNameAcquiredCallback name_acquired_handler, [CCode (type = "GClosure*")] owned GLib.BusNameLostCallback name_lost_handler);
		public void unown_name (uint owner_id);
		public void unwatch_name (uint watcher_id);
		[CCode (cname = "g_bus_watch_name_with_closures")]
		public uint watch_name (GLib.BusType bus_type, string name, GLib.BusNameWatcherFlags flags, [CCode (type = "GClosure*")] owned GLib.BusNameAppearedCallback name_appeared_handler, [CCode (type = "GClosure*")] owned GLib.BusNameVanishedCallback name_vanished_handler);
		[CCode (cname = "g_bus_watch_name_on_connection_with_closures")]
		public uint watch_name_on_connection (GLib.DBusConnection connection, string name, GLib.BusNameWatcherFlags flags, [CCode (type = "GClosure*")] owned GLib.BusNameAppearedCallback name_appeared_handler, [CCode (type = "GClosure*")] owned GLib.BusNameVanishedCallback name_vanished_handler);
	}

	[CCode (cname = "GDBusConnection")]
	public class DBusConnection {
		public T get_proxy_sync<T> (string? name, string object_path, GLib.DBusProxyFlags flags = 0, GLib.Cancellable? cancellable = null) throws GLib.IOError;
		public uint register_object<T> (string object_path, T object) throws GLib.IOError;
	}
}
