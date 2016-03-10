note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EVOLICITY_FILE_LEXER

inherit
	EL_FILE_LEXER
		redefine
			make_parser
		end

	EL_EIFFEL_PATTERN_FACTORY
		rename
			identifier as evolicity_identifier
		end

	EVOLICITY_TOKENS

create
	make

feature {NONE} -- Initialization

	make_parser
			--
		do
			Precursor
			set_unmatched_text_action (add_token_action (Free_text))
			create leading_space_text
		end

feature {NONE} -- Patterns

	new_pattern: EL_TEXTUAL_PATTERN
			--
		do
			Result := one_of (<<
				velocity_directive,
				dollar_literal,
				variable_reference
			>>)
		end

	dollar_literal: EL_LITERAL_TEXTUAL_PATTERN
			-- Eg: ${clip.offset}
		do
			Result := string_literal ("$$") |to| add_token_action (Double_dollor_sign)
		end

	variable_reference: EL_MATCH_ALL_IN_LIST_TP
			-- Eg: ${clip.offset}
		do
			Result := all_of (<<
				character_literal ('$'),
				one_of (<<
					qualified_variable_name,
					parenthesized_qualified_variable_name
				>>)
			>>)
		end

	parenthesized_qualified_variable_name: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('{'),
				qualified_variable_name,
				character_literal ('}')
			>>)
		end

	qualified_variable_name: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				evolicity_identifier 				|to| add_token_action (Unqualified_name),
				zero_or_more (
					all_of (<<
						character_literal ('.') 	|to| add_token_action (Dot_operator),
						evolicity_identifier 		|to| add_token_action (Unqualified_name)
					>>)
				),
				optional (function_call_pattern)
			>>)
		end

	function_call_pattern: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				left_bracket_pattern,
				maybe_non_breaking_white_space,
				constant,
				while_not_pattern_1_repeat_pattern_2 (
					all_of (<<
						maybe_non_breaking_white_space,
						right_bracket_pattern
					>>),
					all_of (<<
						maybe_non_breaking_white_space,
						character_literal (',') 			|to| add_token_action (Comma_sign),
						maybe_non_breaking_white_space,
						constant
					>>)
				)
			>>)
		end

	velocity_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				start_of_line,
				maybe_non_breaking_white_space 	|to| agent on_leading_white_space,
				character_literal ('#'),
				one_of (<<
					string_literal ("end") 			|to| add_token_action (Keyword_end),
					if_directive,
					across_directive,
					foreach_directive,
					string_literal ("else") 		|to| add_token_action (Keyword_else),
					evaluate_directive,
					include_directive
				>>),
				maybe_non_breaking_white_space,
				end_of_line_character
			>>)
		end

	if_directive: EL_MATCH_ALL_IN_LIST_TP
			-- if <simple boolean expression> then
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<	string_literal ("if") 	|to| add_token_action (Keyword_if),
				boolean_expression,
				string_literal ("then") |to| add_token_action (Keyword_then)
			>>)
		end

	foreach_directive: EL_MATCH_ALL_IN_LIST_TP
			-- foreach <var> in <list_var_name> loop
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  string_literal ("foreach")	|to| add_token_action (Keyword_foreach),
				variable_reference,
				string_literal ("in") 			|to| add_token_action (Keyword_in),
				variable_reference,
				string_literal ("loop") 		|to| add_token_action (Keyword_loop)
			>>)
		end

	across_directive: EL_MATCH_ALL_IN_LIST_TP
			-- across <list_var_name> as <var> loop
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  string_literal ("across")	|to| add_token_action (Keyword_across),
				variable_reference,
				string_literal ("as") 		|to| add_token_action (Keyword_as),
				variable_reference,
				string_literal ("loop") 	|to| add_token_action (Keyword_loop)
			>>)
		end

	evaluate_directive: EL_MATCH_ALL_IN_LIST_TP
			-- evaluate ({<type name>}.template, $<variable name>)
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  string_literal ("evaluate") 	|to| agent on_evaluate (Keyword_evaluate, ?),
				character_literal ('('),
				one_of (<<
					template_name_by_class	   |to| add_token_action (Template_name_identifier),
					variable_reference
				>>),
				character_literal (','),
				variable_reference,
				character_literal (')')
			>>)
		end

	include_directive: EL_MATCH_ALL_IN_LIST_TP
			-- include ($<variable name>)
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  string_literal ("include") |to| agent on_include (Keyword_include, ?),
				character_literal ('('),
				variable_reference,
				character_literal (')')
			>>)
		end

	template_name_by_class: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('{'),
				class_identifier,
				string_literal ("}.template")
			>>)
		end

	boolean_expression: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				simple_boolean_expression,
				zero_or_more (
					all_of (<<
						maybe_non_breaking_white_space,
						one_of (<<
							string_literal ("and") 	|to| add_token_action (Boolean_and_operator),
							string_literal ("or") 	|to| add_token_action (Boolean_or_operator)
						>>),
						maybe_non_breaking_white_space,
						simple_boolean_expression
					>>)
				)
			>>)
		end

	simple_boolean_expression: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				boolean_value,
				all_of (<<
					string_literal ("not") |to| add_token_action (Boolean_not_operator),
					maybe_non_breaking_white_space,
					one_of (<< variable_reference, bracketed_boolean_value >>)
				>>)
			>>)
		end

	bracketed_boolean_value: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space, <<
				character_literal ('('), boolean_value, character_literal (')')
			>>)
		end

	boolean_value: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<< simple_comparison_expression, variable_reference >>)
		end

	simple_comparison_expression: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  variable_reference_or_constant,
				comparison_operator,
				variable_reference_or_constant
			>>)
		end

	variable_reference_or_constant: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<< variable_reference, constant >>)
		end

	constant: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				quoted_eiffel_string (Default_match_action)  |to| add_token_action (Quoted_string),
				double_constant									 	|to| add_token_action (Double_constant_token),
				integer_constant 										|to| add_token_action (Integer_64_constant_token)
			>>)
		end

	comparison_operator: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				string_literal (">")  |to| add_token_action (Greater_than_operator),
				string_literal ("<")  |to| add_token_action (Less_than_operator),
				string_literal ("=")  |to| add_token_action (Equal_to_operator),
				string_literal ("/=") |to| add_token_action (Not_equal_to_operator)
--				string_literal ("is_type") |to| add_token_action (Is_type_of_operator)
			>>)

		end

	left_bracket_pattern: EL_LITERAL_CHAR_TP
			--
		do
			Result := character_literal ('(')
			Result.set_action_on_match (add_token_action (Left_bracket))
		end

	right_bracket_pattern: EL_LITERAL_CHAR_TP
			--
		do
			Result := character_literal (')')
			Result.set_action_on_match (add_token_action (Right_bracket))
		end

feature {NONE} -- Actions

	on_leading_white_space (text: EL_STRING_VIEW)
			--
		do
			leading_space_text := text
		end

	on_evaluate, on_include (keyword_token: NATURAL_32; token_text: EL_STRING_VIEW)
			--
		do
			tokens_text.append_code (keyword_token)
			token_text_array.extend (token_text)
			tokens_text.append_code (White_text)
			token_text_array.extend (leading_space_text)
		end

feature {NONE} -- Implementation

	leading_space_text: EL_STRING_VIEW

end
