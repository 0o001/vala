/* doclet.vala
 *
 * Copyright (C) 2010 Luca Bruno
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Luca Bruno <lethalman88@gmail.com>
 */

using Valadoc;
using Valadoc.Api;
using Valadoc.Content;

namespace Gtkdoc.Config {
	public static bool nohtml;
	public static string library_filename;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] ignore_headers;
	public static string deprecated_guards;
	public static string ignore_decorators;

	private static const GLib.OptionEntry[] options = {
			{ "library", 'l', 0, OptionArg.FILENAME, ref library_filename, "Shared library path", "FILENAME" },
			{ "ignore-headers", 'x', 0, OptionArg.FILENAME_ARRAY, ref ignore_headers, "A list of header files to not scan", "FILES" },
			{ "deprecated-guards", 'd', 0, OptionArg.STRING, ref deprecated_guards, "A |-separated list of symbols used as deprecation guards", "GUARDS" },
			{ "ignore-decorators", 0, 0, OptionArg.STRING, ref ignore_decorators, "A |-separated list of addition decorators in declarations that should be ignored", "DECS" },
			{ "nohtml", 0, 0, OptionArg.NONE, ref nohtml, "Disable HTML generation", null },
			{ null }
		};

	public static bool parse (string[] rargs, ErrorReporter reporter) {
		string[] args = { "gtkdoc" };
		foreach (var arg in rargs) {
			args += arg;
		}

		try {
			var opt_context = new OptionContext ("- Vala GTK-Doc");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			unowned string[] gtkdoc_args = args;
			opt_context.parse (ref gtkdoc_args);
		} catch (OptionError e) {
			reporter.simple_error ("GtkDoc: Error: %s\nRun '-X --help' to see a full list of available command line options.".printf (e.message));
			return false;
		}

		// real path to ignored headers
		for (int i=0; i < ignore_headers.length; i++) {
			var realheader = realpath (ignore_headers[i]);
			if (realheader != null) {
				ignore_headers[i] = realheader;
			}
		}

		return true;
	}
}



public class Gtkdoc.Director : Valadoc.Doclet, Object {
	private ErrorReporter reporter;
	private Settings settings;
	private Api.Tree tree;
	private Gtkdoc.Generator generator;
	private string[] vala_headers;
	private string[] c_headers;

	/*
	 * 1) Scan normal code, this generates -decl.txt for both C and Vala.
	 * 2) Scan C code into a temp cscan directory. This generates C sections.
	 *    Move C -sections.txt file to the real output -sections.txt.
	 * 3) Generate and append Vala sections to -sections.txt.
	 * Done. Now we have -decl.txt of the whole code and -sections.txt containing C sections
	 * and Vala sections.
	 */
	public void process (Settings settings, Api.Tree tree, ErrorReporter reporter) {
		this.settings = settings;
		if (!Config.parse (settings.pluginargs, reporter)) {
			return;
		}
		this.reporter = reporter;
		this.tree = tree;

		var ccomments_dir = Path.build_filename (settings.path, "ccomments");
		var cscan_dir = Path.build_filename (settings.path, "cscan");
		DirUtils.create_with_parents (settings.path, 0755);
		DirUtils.create_with_parents (ccomments_dir, 0755);
		DirUtils.create_with_parents (cscan_dir, 0755);

		prepare_external_c_files (tree, ccomments_dir);

		find_files (ccomments_dir);
		if (vala_headers.length <= 0) {
			reporter.simple_error ("GtkDoc: No vala header found");
			return;
		}

		var all_headers = vala_headers;
		foreach (var c_header in c_headers) {
			all_headers += c_header;
		}
		if (!scan (settings.path, all_headers)) {
			return;
		}

		if (!scan (cscan_dir, c_headers)) {
			return;
		}

		FileUtils.rename (Path.build_filename (cscan_dir, "%s-sections.txt".printf (settings.pkg_name)),
						  Path.build_filename (settings.path, "%s-sections.txt".printf (settings.pkg_name)));

		generator = new Gtkdoc.Generator ();
		if (!generator.execute (settings, tree, reporter)) {
			return;
		}

		if (!scangobj ()) {
			return;
		}

		if (!mkdb ()) {
			return;
		}

		if (!mkhtml ()) {
			return;
		}
	}

	private void prepare_external_c_files (Api.Tree tree, string comments_dir) {
		foreach (string filename in tree.get_external_c_files ()) {
			if (!copy_file (filename, Path.build_filename (comments_dir, Path.get_basename (filename)))) {
				reporter.simple_error ("GtkDoc: Can't copy %s".printf (filename));
				return ;
			}
		}
	}

	private void find_files (string comments_dir) {
		vala_headers = new string[]{};
		c_headers = new string[]{};
		Dir dir;
		string dirname = settings.basedir ?? ".";
		try {
			dir = Dir.open (dirname);
		} catch (Error e) {
			reporter.simple_error ("GtkDoc: Can't open %s: %s".printf (settings.basedir, e.message));
			return;
		}

		string relative_name;

		while ((relative_name = dir.read_name()) != null) {
			var filename = realpath (Path.build_filename (dirname, relative_name));
			if (filename == null) {
				continue;
			}

			if (filename.has_suffix (".h")) {
				if (filename in Config.ignore_headers) {
					continue;
				}

				if (is_generated_by_vala (filename)) {
					vala_headers += filename;
				} else {
					c_headers += filename;
				}
			}
		}
	}

	private bool scan (string output_dir, string[]? headers = null) {
		if (headers == null) {
			// nothing to scan
			return true;
		}

		string[] args = { "gtkdoc-scan",
				  "--module", settings.pkg_name,
				  "--output-dir", output_dir,
				  "--rebuild-sections",
				  "--rebuild-types" };

		foreach (var header in headers) {
			args += header;
		}

		if (Config.deprecated_guards != null) {
			args += "--deprecated-guards";
			args += Config.deprecated_guards;
		}

		if (Config.ignore_decorators != null) {
			args += "--ignore-decorators";
			args += Config.ignore_decorators;
		}

		try {
			Process.spawn_sync (settings.path, args, null, SpawnFlags.SEARCH_PATH, null, null, null);
		} catch (Error e) {
			reporter.simple_error ("gtkdoc-scan: %s".printf (e.message));
			return false;
		}

		return true;
	}

	private bool scangobj () {
		if (Config.library_filename == null) {
			return true;
		}

		var library = realpath (Config.library_filename);

		string[] pc = { "pkg-config" };
		foreach (var package in tree.get_package_list()) {
			if (package.is_package && package_exists (package.name, reporter)) {
				pc += package.name;
			}
		}

		var pc_cflags = pc;
		pc_cflags += "--cflags";
		var pc_libs = pc;
		pc_libs += "--libs";
	
		try {
			string stderr;
			int status;

			string cflags;
			Process.spawn_sync (null, pc_cflags, null, SpawnFlags.SEARCH_PATH, null, out cflags, out stderr, out status);
			if (status != 0) {
				reporter.simple_error ("GtkDoc: pkg-config cflags error: %s".printf (stderr));
				return false;
			}
			cflags = cflags.strip ();

			string libs;
			Process.spawn_sync (null, pc_libs, null, SpawnFlags.SEARCH_PATH, null, out libs, out stderr, out status);
			if (status != 0) {
				reporter.simple_error ("GtkDoc: pkg-config libs error: %s".printf (stderr));
				return false;
			}

			libs = libs.strip ();

			string[] args = { "gtkdoc-scangobj",
							  "--module", settings.pkg_name,
							  "--types", "%s.types".printf (settings.pkg_name),
							  "--output-dir", settings.path };

			string[] env = { "CFLAGS=%s %s".printf (cflags,
							Environment.get_variable ("CFLAGS") ?? ""),
							"LDFLAGS=%s %s %s".printf (libs, library,
							Environment.get_variable ("LDFLAGS") ?? ""),
							"LD_LIBRARY_PATH=%s:%s".printf (Path.get_dirname (library),
							Environment.get_variable ("LD_LIBRARY_PATH") ?? "")};
			foreach (var evar in Environment.list_variables()) {
				if (evar != "CFLAGS" && evar != "LDFLAGS" && evar != "LD_LIBRARY_PATH")
					env += "%s=%s".printf (evar, Environment.get_variable(evar));
			}

			Process.spawn_sync (settings.path, args, env, SpawnFlags.SEARCH_PATH, null, null, null);
		} catch (Error e) {
			reporter.simple_error ("gtkdoc-scangobj: %s".printf (e.message));
			return false;
		}

		return true;
	}

	private bool mkdb () {
		var main_file = Path.build_filename (settings.path, "%s-docs.xml".printf (settings.pkg_name));
		var code_dir = Path.build_filename (settings.path, "ccomments");
		var must_update_main_file = !FileUtils.test (main_file, FileTest.EXISTS);

		var args = new string[] { "gtkdoc-mkdb",
					  "--module", settings.pkg_name,
					  "--source-dir", code_dir,
					  "--output-format", "xml",
					  "--sgml-mode",
					  "--main-sgml-file", "%s-docs.xml".printf (settings.pkg_name),
					  "--name-space", settings.pkg_name };

		try {
			Process.spawn_sync (settings.path, args, null, SpawnFlags.SEARCH_PATH, null, null, null);
		} catch (Error e) {
			reporter.simple_error ("gtkdoc-mkdb: %s".printf (e.message));
			return false;
		}

		if (must_update_main_file) {
			// gtkdoc-mkdb created a template main file, but users expect it to be a bit more complete
			string contents;
			try {
				FileUtils.get_contents (main_file, out contents);
			} catch (Error e) {
				reporter.simple_error ("GtkDoc: Error while reading main file '%s' contents: %s".printf (main_file, e.message));
				return false;
			}

			if (settings.pkg_version != null) {
				contents = contents.replace ("[VERSION]", settings.pkg_version);
			}
			contents = contents.replace ("[Insert title here]", "%s API Reference".printf (settings.pkg_name));

			if (generator.dbus_interfaces.size > 0) {
				// hackish but prevents us from re-creating the whole main file,
				// which would more even more hackish
				var builder = new StringBuilder ();
				builder.append_printf ("\n<chapter>\n<title>%s D-Bus API Reference</title>\n", settings.pkg_name);
				foreach (var iface in generator.dbus_interfaces) {
					builder.append_printf ("<xi:include href=\"xml/%s.xml\"/>\n", to_docbook_id (iface.name));
				}

				var hierarchy_file = Path.build_filename (settings.path, "%s.hierarchy".printf (settings.pkg_name));
				if (FileUtils.test (hierarchy_file, FileTest.EXISTS)) {
					// if hierarchy exists, gtkdoc-mkdb will output it
					builder.append ("</chapter>\n<chapter id=\"object-tree\">");
					contents = contents.replace ("<chapter id=\"object-tree\">", builder.str);
				} else {
					builder.append ("</chapter>\n<index id=\"api-index-full\">");
					contents = contents.replace ("<index id=\"api-index-full\">", builder.str);
				}
			}

			try {
				FileUtils.set_contents (main_file, contents);
			} catch (Error e) {
				reporter.simple_error ("GtkDoc: Error while writing main file '%s' contents: %s".printf (main_file, e.message));
				return false;
			}
		}

		return true;
	}

	private bool mkhtml () {
		if (Config.nohtml) {
			return true;
		}

		var html_dir = Path.build_filename (settings.path, "html");
		DirUtils.create_with_parents (html_dir, 0755);

		try {
			Process.spawn_sync (html_dir,
						{"gtkdoc-mkhtml",
						  settings.pkg_name, "../%s-docs.xml".printf (settings.pkg_name)},
						null, SpawnFlags.SEARCH_PATH, null, null, null);
		} catch (Error e) {
			reporter.simple_error ("gtkdoc-mkhtml: %s".printf (e.message));
			return false;
		}

		/* fix xrefs for regenerated html */
		try {
			Process.spawn_sync (settings.path,
						{ "gtkdoc-fixxref",
						  "--module", settings.pkg_name,
						  "--module-dir", html_dir,
						  "--html-dir", html_dir },
						null, SpawnFlags.SEARCH_PATH, null, null, null);
		} catch (Error e) {
			reporter.simple_error ("gtkdoc-fixxref: %s".printf (e.message));
			return false;
		}

		return true;
	}
}

[ModuleInit]
public Type register_plugin (GLib.TypeModule module) {
	return typeof (Gtkdoc.Director);
}


