/* list.vala
 *
 * Copyright (C) 2008-2009 Florian Brosch, Didier Villevalois
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

using Gee;


public class Valadoc.Content.List : ContentElement, Block {
	public enum Bullet {
		NONE,
		UNORDERED,
		ORDERED,
		ORDERED_NUMBER,
		ORDERED_LOWER_CASE_ALPHA,
		ORDERED_UPPER_CASE_ALPHA,
		ORDERED_LOWER_CASE_ROMAN,
		ORDERED_UPPER_CASE_ROMAN
	}

	public Bullet bullet { get; set; }
	// TODO add initial value (either a number or some letters)
	public Gee.List<ListItem> items { get { return _items; } }

	private Gee.List<ListItem> _items;

	internal List () {
		base ();
		_bullet = Bullet.NONE;
		_items = new ArrayList<ListItem> ();
	}

	public override void check (Api.Tree api_root, Api.Node? container, ErrorReporter reporter) {
		// Check individual list items
		foreach (ListItem element in _items) {
			element.check (api_root, container, reporter);
		}
	}

	public override void accept (ContentVisitor visitor) {
		visitor.visit_list (this);
	}

	public override void accept_children (ContentVisitor visitor) {
		foreach (ListItem element in _items) {
			element.accept (visitor);
		}
	}
}
