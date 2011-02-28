/* enumvalue.vala
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
 * Represents an enum member.
 */
public class Valadoc.Api.EnumValue: Symbol {
	public EnumValue (Vala.EnumValue symbol, Node parent) {
		base (symbol, parent);
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool is_public {
		get {
			return ((Enum)parent).is_public;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool is_protected {
		get {
			return ((Enum)parent).is_protected;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool is_internal {
		get {
			return ((Enum)parent).is_internal;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool is_private {
		get {
			return ((Enum)parent).is_private;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	internal override void process_comments (Settings settings, DocumentationParser parser) {
		var source_comment = ((Vala.EnumValue) symbol).comment;
		if (source_comment != null) {
			documentation = parser.parse (this, source_comment);
		}

		base.process_comments (settings, parser);
	}

	/**
	 * Returns the name of this enum value as it is used in C.
	 */
	public string get_cname () {
		return ((Vala.EnumValue) symbol).get_cname ();
	}

	/**
	 * {@inheritDoc}
	 */
	public override NodeType node_type { get { return NodeType.ENUM_VALUE; } }

	/**
	 * {@inheritDoc}
	 */
	public override void accept (Visitor visitor) {
		visitor.visit_enum_value (this);
	}

	/**
	 * {@inheritDoc}
	 */
	protected override Inline build_signature () {
		var builder = new SignatureBuilder ()
				.append_symbol (this);

		if (((Vala.EnumValue) symbol).value != null) {
			builder.append ("=")
				.append (((Vala.EnumValue) symbol).value.to_string ());
		}

		return builder.get ();
	}
}

