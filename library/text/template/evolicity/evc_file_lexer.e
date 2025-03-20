note
	description: "Evolicity file lexer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 7:38:56 GMT (Thursday 20th March 2025)"
	revision: "20"

class
	EVC_FILE_LEXER

inherit
	EL_FILE_LEXER
		export
			{NONE} all
		redefine
			fill_tokens_text
		end

	TP_EIFFEL_FACTORY
		rename
			identifier as evolicity_identifier
		end

	EVC_SHARED_TOKEN_ENUM

create
	make

feature -- Basic operations

	fill_tokens_text
		do
			find_all (add_token_action (Token.Free_text))
		end

feature {NONE} -- Expression Pattern

	boolean_expression: like all_of
			--
		do
			Result := all_of (<<
				simple_boolean_expression,
				zero_or_more (
					all_of (<<
						optional_nonbreaking_white_space,
						one_of (<<
							text_token ("and", Token.keyword_and),
							text_token ("or", Token.keyword_or)
						>>),
						optional_nonbreaking_white_space,
						simple_boolean_expression
					>>)
				)
			>>)
		end

	boolean_value: like one_of
			--
		do
			Result := one_of (<< simple_comparison_expression, variable_reference >>)
		end

	bracketed_boolean_value: like all_of
			--
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				character_literal ('('), boolean_value, character_literal (')')
			>>)
		end

	comparison_operator: like one_of
			--
		do
			Result := one_of (<<
				text_token (">", Token.operator_greater_than),
				text_token ("<", Token.operator_less_than),
				text_token ("=", Token.operator_equal_to),
				text_token ("/=", Token.operator_not_equal_to)
--				string_literal ("is_type") |to| add_token_action (Is_type_of_operator)
			>>)
		end

	simple_boolean_expression: like one_of
			--
		do
			Result := one_of (<<
				boolean_value,
				all_of (<<
					text_token ("not", Token.keyword_not),
					optional_nonbreaking_white_space,
					one_of (<< variable_reference, bracketed_boolean_value >>)
				>>)
			>>)
		end

	simple_comparison_expression: like all_of
			--
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				value_reference, comparison_operator, value_reference
			>>)
		end

feature {NONE} -- Value Pattern

	constant: like one_of
			--
		do
			Result := one_of (<<
				quoted_string (Void)	|to| add_token_action (Token.Literal_string),
				signed_integer 		|to| add_token_action (Token.Literal_integer),
				decimal_constant		|to| add_token_action (Token.literal_real)
			>>)
		end

	function_argument: like one_of
		do
			Result := one_of (<< variable_reference, constant >>)
		end

	function_call: like all_of
		-- Eg. @row.formatted ($row.posted_date, "dd Mmm yyyy")
		do
			Result := all_of (<<
				character_literal ('@')							|to| add_token_action (Token.at_sign),
				qualified_evolicity_identifier,
				optional_nonbreaking_white_space,
				character_literal ('(') 						|to| add_token_action (Token.Left_bracket),
				optional_nonbreaking_white_space,
				function_argument,
				zero_or_more (
					all_of (<<
						optional_nonbreaking_white_space,
						character_literal (',')					|to| add_token_action (Token.Comma_sign),
						optional_nonbreaking_white_space,
						function_argument
					>>)
				),
				character_literal (')')							|to| add_token_action (Token.Right_bracket)
			>>)
		end

	qualified_evolicity_identifier: like all_of
			--
		do
			Result := all_of (<<
				evolicity_identifier 				|to| add_token_action (Token.Unqualified_name),
				zero_or_more (
					all_of (<<
						character_literal ('.') 	|to| add_token_action (Token.operator_dot),
						evolicity_identifier 		|to| add_token_action (Token.Unqualified_name)
					>>)
				)
			>>)
		end

	variable_reference: like all_of
		-- Eg: ${clip.offset} OR $clip.offset
		do
			Result := all_of (<<
				character_literal ('$'),
				one_of (<<
					all_of (<< character_literal ('{'), qualified_evolicity_identifier, character_literal ('}') >>),
					all_of (<< qualified_evolicity_identifier >> )
				>>)
			>>)
		end

	value_reference: like one_of
		do
			Result := one_of (<< variable_reference, constant, function_call >>)
		end

feature {NONE} -- Directive Pattern

	across_directive: like all_of
			-- across <list_var_name> as <var> loop
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space,

			<< text_token ("across", Token.keyword_across),
				variable_reference,
				text_token ("as", Token.keyword_as),
				variable_reference,
				text_token ("loop", Token.keyword_loop)
			>>)
		end

	evolicity_directive: like all_of
			--
		do
			Result := all_of (<<
				leading_white_space,
				character_literal ('#'),
				one_of (<<
					text_token ("end", Token.keyword_end),
					if_directive,
					across_directive,
					foreach_directive,
					text_token ("else", Token.keyword_else),
					evaluate_directive,
					include_directive
				>>),
				optional_nonbreaking_white_space,
				end_of_line_character
			>>)
		end

	evaluate_directive: like all_of
			-- evaluate ({<type name>}.template, $<variable name>)
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space,

			<< string_literal ("evaluate") |to| agent on_evaluate (Token.keyword_evaluate, ?, ?),
				character_literal ('('),
				one_of (<<
					quoted_string (Void) |to| add_token_action (Token.Literal_string),
					template_name_by_class |to| add_token_action (Token.Template_name_identifier),
					variable_reference
				>>),
				character_literal (','),
				variable_reference,
				character_literal (')')
			>>)
		end

	foreach_directive: like all_of
			-- foreach <var> in <list_var_name> loop
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				text_token ("foreach", Token.keyword_foreach),
				variable_reference,
				optional (
--					table key variable
					all_of (<<
						character_literal (','), optional_nonbreaking_white_space, variable_reference
					>>)
				),
				text_token ("in", Token.keyword_in),
				variable_reference,
				text_token ("loop", Token.keyword_loop)
			>>)
		end

	if_directive: like all_of
			-- if <simple boolean expression> then
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				text_token ("if", Token.keyword_if), boolean_expression, text_token ("then", Token.keyword_then)
			>>)
		end

	include_directive: like all_of
			-- include ($<variable name>)
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				string_literal ("include") |to| agent on_include (Token.keyword_include, ?, ?),
				character_literal ('('),
				one_of (<<
					quoted_string (Void) |to| add_token_action (Token.Literal_string),
					variable_reference
				>>),
				character_literal (')')
			>>)
		end

	leading_white_space: like all_of
		-- Fixes bug where #evaluate with no leading space uses tab count of previous #evaluate
		do
			Result := all_of (<< start_of_line, optional_nonbreaking_white_space >>)
			Result.set_action_first (agent on_leading_white_space)
		end

feature {NONE} -- Other Pattern

	dollar_literal: like string_literal
			-- Example in Bash script

			-- RETVAL=$?
			-- if [ $$RETVAL -eq 0 ]
			-- then
		do
			Result := text_token ("$$", Token.Double_dollor_sign)
		end

	template_name_by_class: like all_of
			--
		do
			Result := all_of (<< character_literal ('{'), class_name, string_literal ("}.template") >>)
		end

feature {NONE} -- Actions

	on_evaluate, on_include (keyword_token: NATURAL_32; start_index, end_index: INTEGER)
			--
		local
			lower, upper: INTEGER
		do
			tokens_text.append_code (keyword_token)
			source_interval_list.extend (start_index, end_index)
			tokens_text.append_code (Token.White_text)
			lower := (leading_space_text |>> 32).to_integer_32
			upper := leading_space_text.to_integer_32
			source_interval_list.extend (lower, upper)
		end

	on_leading_white_space (start_index, end_index: INTEGER)
			--
		do
			leading_space_text := (start_index.to_integer_64 |<< 32) | end_index.to_integer_64
		end

feature {NONE} -- Factory

	new_pattern: like one_of
			--
		do
			Result := one_of (<< evolicity_directive, dollar_literal, one_of (<< variable_reference, function_call >>) >>)
		end

feature {NONE} -- Internal attributes

	leading_space_text: INTEGER_64

end