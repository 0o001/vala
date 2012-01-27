/* tagletthrows.vala
 *
 * Copyright (C) 2008-2009 Didier Villevalois
 * Copyright (C) 2008-2012 Florian Brosch
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
using Valadoc.Content;

public class Valadoc.Taglets.Throws : InlineContent, Taglet, Block {
	public string error_domain_name { private set; get; }
	public Api.Node error_domain { private set; get; }

	public Rule? get_parser_rule (Rule run_rule) {
		return Rule.seq ({
			Rule.option ({ Rule.many ({ TokenType.SPACE }) }),
			TokenType.any_word ().action ((token) => { error_domain_name = token.to_string (); }),
			run_rule
		});
	}

	public override void check (Api.Tree api_root, Api.Node container, string file_path, ErrorReporter reporter, Settings settings) {
		error_domain = api_root.search_symbol_str (container, error_domain_name);
		if (error_domain == null) {
			// TODO use ContentElement's source reference
			reporter.simple_error ("%s does not exist", error_domain_name);
		}

		base.check (api_root, container, file_path, reporter, settings);
	}

	public override void accept (ContentVisitor visitor) {
		visitor.visit_taglet (this);
	}
}

