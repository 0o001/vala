/* signal.vala
 *
 * Copyright (C) 2008  Florian Brosch
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
 * 	Florian Brosch <flo.brosch@gmail.com>
 */

using Gee;
using Valadoc.Content;


/**
 * Represents an signal.
 */
public class Valadoc.Api.Signal : Member {
	public Signal (Vala.Signal symbol, Node parent) {
		base (symbol, parent);
		return_type = new TypeReference (symbol.return_type, this);
	}

	/**
	 * Returns the name of this signal as it is used in C.
	 */
	public string? get_cname () {
		return ((Vala.Signal) symbol).get_cname();
	}

	/**
	 * Returns the dbus-name.
	 */
	public string get_dbus_name () {
		return Vala.DBusModule.get_dbus_name_for_member (symbol);
	}

	/**
	 * The return type of this signal.
	 *
	 * @return The return type of this signal or null for void
	 */
	public TypeReference? return_type { protected set; get; }

	/**
	 * {@inheritDoc}
	 */
	internal override void resolve_type_references (Tree root) {
		return_type.resolve_type_references (root);

		base.resolve_type_references (root);
	}

	/**
	 * Specifies whether this signal is virtual
	 */
	public bool is_virtual {
		get {
			return ((Vala.Signal) symbol).is_virtual;
		}
	}

	/**
	 * Specifies whether this signal is visible for dbus
	 */
	public bool is_dbus_visible {
		get {
			return Vala.DBusServerModule.is_dbus_visible (symbol);
		}
	}

	/**
	 * {@inheritDoc}
	 */
	protected override Inline build_signature () {
		var signature = new SignatureBuilder ();

		signature.append_keyword (get_accessibility_modifier ());
		if (is_virtual) {
			signature.append_keyword ("virtual");
		}

		signature.append_content (return_type.signature);
		signature.append_symbol (this);
		signature.append ("(");

		bool first = true;
		foreach (Node param in get_children_by_type (NodeType.FORMAL_PARAMETER)) {
			if (!first) {
				signature.append (",", false);
			}
			signature.append_content (param.signature, !first);
			first = false;
		}

		signature.append (")", false);

		return signature.get ();
	}

	/**
	 * {@inheritDoc}
	 */
	public override NodeType node_type { get { return NodeType.SIGNAL; } }

	/**
	 * {@inheritDoc}
	 */
	public override void accept (Visitor visitor) {
		visitor.visit_signal (this);
	}
}

