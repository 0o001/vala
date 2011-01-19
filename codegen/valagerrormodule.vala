/* valagerrormodule.vala
 *
 * Copyright (C) 2008-2010  Jürg Billeter
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
 *	Jürg Billeter <j@bitron.ch>
 *	Thijs Vermeir <thijsvermeir@gmail.com>
 */

using GLib;

public class Vala.GErrorModule : CCodeDelegateModule {
	private int current_try_id = 0;
	private int next_try_id = 0;
	private bool is_in_catch = false;

	public override void generate_error_domain_declaration (ErrorDomain edomain, CCodeFile decl_space) {
		if (add_symbol_declaration (decl_space, edomain, edomain.get_cname ())) {
			return;
		}

		var cenum = new CCodeEnum (edomain.get_cname ());

		foreach (ErrorCode ecode in edomain.get_codes ()) {
			if (ecode.value == null) {
				cenum.add_value (new CCodeEnumValue (ecode.get_cname ()));
			} else {
				ecode.value.emit (this);
				cenum.add_value (new CCodeEnumValue (ecode.get_cname (), get_cvalue (ecode.value)));
			}
		}

		decl_space.add_type_definition (cenum);

		string quark_fun_name = edomain.get_lower_case_cprefix () + "quark";

		var error_domain_define = new CCodeMacroReplacement (edomain.get_upper_case_cname (), quark_fun_name + " ()");
		decl_space.add_type_definition (error_domain_define);

		var cquark_fun = new CCodeFunction (quark_fun_name, gquark_type.data_type.get_cname ());

		decl_space.add_function_declaration (cquark_fun);
	}

	public override void visit_error_domain (ErrorDomain edomain) {
		if (edomain.comment != null) {
			cfile.add_type_definition (new CCodeComment (edomain.comment.content));
		}

		generate_error_domain_declaration (edomain, cfile);

		if (!edomain.is_internal_symbol ()) {
			generate_error_domain_declaration (edomain, header_file);
		}
		if (!edomain.is_private_symbol ()) {
			generate_error_domain_declaration (edomain, internal_header_file);
		}

		string quark_fun_name = edomain.get_lower_case_cprefix () + "quark";

		var cquark_fun = new CCodeFunction (quark_fun_name, gquark_type.data_type.get_cname ());
		var cquark_block = new CCodeBlock ();

		var cquark_call = new CCodeFunctionCall (new CCodeIdentifier ("g_quark_from_static_string"));
		cquark_call.add_argument (new CCodeConstant ("\"" + edomain.get_lower_case_cname () + "-quark\""));

		cquark_block.add_statement (new CCodeReturnStatement (cquark_call));

		cquark_fun.block = cquark_block;
		cfile.add_function (cquark_fun);
	}

	public override void visit_throw_statement (ThrowStatement stmt) {
		// method will fail
		current_method_inner_error = true;
		ccode.add_assignment (get_variable_cexpression ("_inner_error_"), get_cvalue (stmt.error_expression));

		add_simple_check (stmt, true);
	}

	public virtual void return_with_exception (CCodeExpression error_expr) {
		var cpropagate = new CCodeFunctionCall (new CCodeIdentifier ("g_propagate_error"));
		cpropagate.add_argument (new CCodeIdentifier ("error"));
		cpropagate.add_argument (error_expr);

		ccode.add_expression (cpropagate);

		// free local variables
		append_local_free (current_symbol, false);

		if (current_method is CreationMethod && current_method.parent_symbol is Class) {
			var cl = (Class) current_method.parent_symbol;
			var unref_call = get_unref_expression (new CCodeIdentifier ("self"), new ObjectType (cl), null);
			ccode.add_expression (unref_call);
			ccode.add_return (new CCodeConstant ("NULL"));
		} else if (current_method != null && current_method.coroutine) {
			ccode.add_return (new CCodeConstant ("FALSE"));
		} else {
			return_default_value (current_return_type);
		}
	}

	void uncaught_error_statement (CCodeExpression inner_error, bool unexpected = false) {
		// free local variables
		append_local_free (current_symbol, false);

		var ccritical = new CCodeFunctionCall (new CCodeIdentifier ("g_critical"));
		ccritical.add_argument (new CCodeConstant (unexpected ? "\"file %s: line %d: unexpected error: %s (%s, %d)\"" : "\"file %s: line %d: uncaught error: %s (%s, %d)\""));
		ccritical.add_argument (new CCodeConstant ("__FILE__"));
		ccritical.add_argument (new CCodeConstant ("__LINE__"));
		ccritical.add_argument (new CCodeMemberAccess.pointer (inner_error, "message"));
		var domain_name = new CCodeFunctionCall (new CCodeIdentifier ("g_quark_to_string"));
		domain_name.add_argument (new CCodeMemberAccess.pointer (inner_error, "domain"));
		ccritical.add_argument (domain_name);
		ccritical.add_argument (new CCodeMemberAccess.pointer (inner_error, "code"));

		var cclear = new CCodeFunctionCall (new CCodeIdentifier ("g_clear_error"));
		cclear.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.ADDRESS_OF, inner_error));

		// print critical message
		ccode.add_expression (ccritical);
		ccode.add_expression (cclear);

		if (is_in_constructor () || is_in_destructor ()) {
			// just print critical, do not return prematurely
		} else if (current_method is CreationMethod) {
			if (current_method.parent_symbol is Struct) {
				ccode.add_return ();
			} else {
				ccode.add_return (new CCodeConstant ("NULL"));
			}
		} else if (current_method != null && current_method.coroutine) {
			ccode.add_return (new CCodeConstant ("FALSE"));
		} else if (current_return_type != null) {
			return_default_value (current_return_type);
		}
	}

	bool in_finally_block (CodeNode node) {
		var current_node = node;
		while (current_node != null) {
			var try_stmt = current_node.parent_node as TryStatement;
			if (try_stmt != null && try_stmt.finally_body == current_node) {
				return true;
			}
			current_node = current_node.parent_node;
		}
		return false;
	}

	public override void add_simple_check (CodeNode node, bool always_fails = false) {
		current_method_inner_error = true;

		var inner_error = get_variable_cexpression ("_inner_error_");

		if (always_fails) {
			// inner_error is always set, avoid unnecessary if statement
			// eliminates C warnings
		} else {
			var ccond = new CCodeBinaryExpression (CCodeBinaryOperator.INEQUALITY, inner_error, new CCodeConstant ("NULL"));
			ccode.open_if (ccond);
		}

		if (current_try != null) {
			// surrounding try found

			// free local variables
			if (is_in_catch) {
				append_local_free (current_symbol, false, current_catch);
			} else {
				append_local_free (current_symbol, false, current_try);
			}

			var error_types = new ArrayList<DataType> ();
			foreach (DataType node_error_type in node.get_error_types ()) {
				error_types.add (node_error_type);
			}

			bool has_general_catch_clause = false;

			if (!is_in_catch) {
				var handled_error_types = new ArrayList<DataType> ();
				foreach (CatchClause clause in current_try.get_catch_clauses ()) {
					// keep track of unhandled error types
					foreach (DataType node_error_type in error_types) {
						if (clause.error_type == null || node_error_type.compatible (clause.error_type)) {
							handled_error_types.add (node_error_type);
						}
					}
					foreach (DataType handled_error_type in handled_error_types) {
						error_types.remove (handled_error_type);
					}
					handled_error_types.clear ();

					if (clause.error_type.equals (gerror_type)) {
						// general catch clause, this should be the last one
						has_general_catch_clause = true;
						ccode.add_goto (clause.clabel_name);
						break;
					} else {
						var catch_type = clause.error_type as ErrorType;

						if (catch_type.error_code != null) {
							/* catch clause specifies a specific error code */
							var error_match = new CCodeFunctionCall (new CCodeIdentifier ("g_error_matches"));
							error_match.add_argument (inner_error);
							error_match.add_argument (new CCodeIdentifier (catch_type.data_type.get_upper_case_cname ()));
							error_match.add_argument (new CCodeIdentifier (catch_type.error_code.get_cname ()));

							ccode.open_if (error_match);
						} else {
							/* catch clause specifies a full error domain */
							var ccond = new CCodeBinaryExpression (CCodeBinaryOperator.EQUALITY,
									new CCodeMemberAccess.pointer (inner_error, "domain"), new CCodeIdentifier
									(clause.error_type.data_type.get_upper_case_cname ()));

							ccode.open_if (ccond);
						}

						// go to catch clause if error domain matches
						ccode.add_goto (clause.clabel_name);
						ccode.close ();
					}
				}
			}

			if (has_general_catch_clause) {
				// every possible error is already caught
				// as there is a general catch clause
				// no need to do anything else
			} else if (error_types.size > 0) {
				// go to finally clause if no catch clause matches
				// and there are still unhandled error types
				ccode.add_goto ("__finally%d".printf (current_try_id));
			} else if (in_finally_block (node)) {
				// do not check unexpected errors happening within finally blocks
				// as jump out of finally block is not supported
			} else {
				// should never happen with correct bindings
				uncaught_error_statement (inner_error, true);
			}
		} else if (current_method != null && current_method.get_error_types ().size > 0) {
			// current method can fail, propagate error
			CCodeBinaryExpression ccond = null;

			foreach (DataType error_type in current_method.get_error_types ()) {
				// If GLib.Error is allowed we propagate everything
				if (error_type.equals (gerror_type)) {
					ccond = null;
					break;
				}

				// Check the allowed error domains to propagate
				var domain_check = new CCodeBinaryExpression (CCodeBinaryOperator.EQUALITY, new CCodeMemberAccess.pointer
					(inner_error, "domain"), new CCodeIdentifier (error_type.data_type.get_upper_case_cname ()));
				if (ccond == null) {
					ccond = domain_check;
				} else {
					ccond = new CCodeBinaryExpression (CCodeBinaryOperator.OR, ccond, domain_check);
				}
			}

			if (ccond != null) {
				ccode.open_if (ccond);
				return_with_exception (inner_error);

				ccode.add_else ();
				uncaught_error_statement (inner_error);
				ccode.close ();
			} else {
				return_with_exception (inner_error);
			}
		} else {
			uncaught_error_statement (inner_error);
		}

		if (!always_fails) {
			ccode.close ();
		}
	}

	public override void visit_try_statement (TryStatement stmt) {
		int this_try_id = next_try_id++;

		var old_try = current_try;
		var old_try_id = current_try_id;
		var old_is_in_catch = is_in_catch;
		var old_catch = current_catch;
		current_try = stmt;
		current_try_id = this_try_id;
		is_in_catch = true;

		foreach (CatchClause clause in stmt.get_catch_clauses ()) {
			clause.clabel_name = "__catch%d_%s".printf (this_try_id, clause.error_type.get_lower_case_cname ());
		}

		is_in_catch = false;
		stmt.body.emit (this);
		is_in_catch = true;

		foreach (CatchClause clause in stmt.get_catch_clauses ()) {
			current_catch = clause;
			ccode.add_goto ("__finally%d".printf (this_try_id));
			clause.emit (this);
		}

		current_try = old_try;
		current_try_id = old_try_id;
		is_in_catch = old_is_in_catch;
		current_catch = old_catch;

		ccode.add_label ("__finally%d".printf (this_try_id));
		if (stmt.finally_body != null) {
			stmt.finally_body.emit (this);
		}

		// check for errors not handled by this try statement
		// may be handled by outer try statements or propagated
		add_simple_check (stmt, !stmt.after_try_block_reachable);
	}

	public override void visit_catch_clause (CatchClause clause) {
		current_method_inner_error = true;

		var error_type = (ErrorType) clause.error_type;
		if (error_type.error_domain != null) {
			generate_error_domain_declaration (error_type.error_domain, cfile);
		}

		ccode.add_label (clause.clabel_name);

		ccode.open_block ();

		string variable_name;
		if (clause.variable_name != null) {
			variable_name = get_variable_cname (clause.variable_name);
		} else {
			variable_name = "__err";
		}

		if (clause.variable_name != null) {
			if (current_method != null && current_method.coroutine) {
				closure_struct.add_field ("GError *", variable_name);
			} else {
				ccode.add_declaration ("GError *", new CCodeVariableDeclarator (variable_name));
			}
			ccode.add_assignment (get_variable_cexpression (variable_name), get_variable_cexpression ("_inner_error_"));
		} else {
			// error object is not used within catch statement, clear it
			var cclear = new CCodeFunctionCall (new CCodeIdentifier ("g_clear_error"));
			cclear.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.ADDRESS_OF, get_variable_cexpression ("_inner_error_")));
			ccode.add_expression (cclear);
		}
		ccode.add_assignment (get_variable_cexpression ("_inner_error_"), new CCodeConstant ("NULL"));

		clause.body.emit (this);

		ccode.close ();
	}

	public override void append_local_free (Symbol sym, bool stop_at_loop = false, CodeNode? stop_at = null) {
		if (!(stop_at is TryStatement || stop_at is CatchClause)) {
			var finally_block = (Block) null;
			if (sym.parent_node is TryStatement) {
				finally_block = (sym.parent_node as TryStatement).finally_body;
			} else if (sym.parent_node is CatchClause) {
				finally_block = (sym.parent_node.parent_node as TryStatement).finally_body;
			}

			if (finally_block != null && finally_block != sym) {
				finally_block.emit (this);
			}
		}

		base.append_local_free (sym, stop_at_loop, stop_at);
	}
}

// vim:sw=8 noet
