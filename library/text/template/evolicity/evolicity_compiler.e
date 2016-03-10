note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 10:05:35 GMT (Saturday 4th January 2014)"
	revision: "4"

class
	EVOLICITY_COMPILER

inherit
	EL_TOKEN_PARSER [EVOLICITY_FILE_LEXER]
		rename
			new_pattern as compound_directive_pattern,
			match_full as parse,
			full_match_succeeded as parse_succeeded,
			call_events as compile
		redefine
			set_source_text_from_file
		end

	EL_TEXTUAL_PATTERN_FACTORY

	EVOLICITY_TOKENS

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create modification_time.make (0, 0, 0, 0, 0, 0)
			reset_directives
		end

feature -- Access

	compiled_template: EVOLICITY_COMPILED_TEMPLATE
		do
			reset_directives
			compile
			create Result.make (compound_directive.to_array, modification_time, has_file_source)
			Result.set_minimum_buffer_length ((source_text.count * 1.5).floor)
		end

	modification_time: DATE_TIME

feature -- Element change

 	set_source_text_from_file (file_path: EL_FILE_PATH)
		do
			modification_time := file_path.modification_time
			has_file_source := True
			Precursor (file_path)
		end

feature {NONE} -- Status query

	has_file_source: BOOLEAN

feature {NONE} -- Patterns

	if_else_end_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Keyword_if) 			|to| agent on_if,
				boolean_expression,
				token (Keyword_then) 		|to| agent on_if_then,
				optional (compound_directive_pattern),
				optional (else_directive)	|to| agent on_else,
				token (Keyword_end) 			|to| agent on_if_else_end
			>> )
		end

	else_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Keyword_else),
				optional (compound_directive_pattern)
			>> )
		end

	foreach_directive: EL_MATCH_ALL_IN_LIST_TP
			-- Match: foreach ( V in V )
		do
			Result := all_of (<<
				token (Keyword_foreach)		|to| agent on_loop_directive (?, False),
				variable_reference			|to| agent on_loop_iterator,
				token (Keyword_in),
				variable_reference 			|to| agent on_loop_traversable_container,
				token (Keyword_loop),
				optional (compound_directive_pattern),
				token (Keyword_end)			|to| agent on_loop_end
			>> )
--			Result.set_debug_to_depth (2)
		end

	across_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Keyword_across)		|to| agent on_loop_directive (?, True),
				variable_reference 			|to| agent on_loop_traversable_container,
				token (Keyword_as),
				variable_reference			|to| agent on_loop_iterator,
				token (Keyword_loop),
				optional (compound_directive_pattern),
				token (Keyword_end)			|to| agent on_loop_end
			>> )
--			Result.set_debug_to_depth (2)
		end

	control_directive: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<< foreach_directive, across_directive, if_else_end_directive>> )
--			Result.set_debug_to_depth (3)
		end

	evaluate_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Keyword_evaluate)				|to| agent on_evaluate,
				token (White_text)						|to| agent on_evaluate_leading_space,
				one_of (<<
					token (Template_name_identifier)	|to| agent on_evaluate_template_identifier,
					variable_reference 					|to| agent on_evaluate_template_name_reference
				>>),
				variable_reference 						|to| agent on_evaluate_variable_reference
			>> )
		end

	include_directive: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Keyword_include)		|to| agent on_include,
				token (White_text)			|to| agent on_include_leading_space,
				variable_reference 			|to| agent on_include_variable_reference
			>> )
		end

	compound_directive_pattern: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (directive)
		end

	directive: EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of_or_else_recursive_pattern (
				<< token (Free_text)				|to| agent on_free_text,
					token (Double_dollor_sign) |to| agent on_dollor_sign_escape,
					variable_reference 			|to| agent on_variable_reference,
					evaluate_directive,
					include_directive
				>>,
				agent control_directive
			)
		end

	variable_reference: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Unqualified_name),
				zero_or_more (
					all_of (<<
						token (Dot_operator),
						token (Unqualified_name)
					>> )
				),
				optional (function_call)
			>>)
		end

	function_call: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				token (Left_bracket),
				constant_pattern,
				while_not_pattern_1_repeat_pattern_2 (
					token (Right_bracket),
					all_of (<<
						token (Comma_sign),
						constant_pattern
					>>)
				)
			>>)
		end

--	type_comparison_expression: EL_MATCH_ALL_IN_LIST_TP is
--			--
--		do
--			Result := all_of ( <<
--				variable_reference,
--				token (Is_type_of_operator),
--				token (Class_name_identifier)
--			>>)
--		end
--
	numeric_comparison_expression: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of (<<
					variable_reference 						|to| agent on_comparison_variable_reference,
					token (Integer_64_constant_token)	|to| agent on_integer_64_comparison,
					token (Double_constant_token)			|to| agent on_double_comparison
				>>),
				numeric_comparison_operator,
				one_of (<<
					variable_reference 						|to| agent on_comparison_variable_reference,
					token (Integer_64_constant_token) 	|to| agent on_integer_64_comparison,
					token (Double_constant_token) 		|to| agent on_double_comparison
				>>)
			>>)
			Result.set_action_on_match_end (
				agent on_comparison_expression
			)
		end

	numeric_comparison_operator: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := one_of ( <<
				token (Less_than_operator) 	|to| agent on_less_than_numeric_comparison,
				token (Greater_than_operator) |to| agent on_greater_than_numeric_comparison,
				token (Equal_to_operator) 		|to| agent on_equal_to_numeric_comparison,
				token (Not_equal_to_operator)
			>>)
		end

	simple_boolean_expression: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				negated_boolean_value, boolean_value
			>>)
		end

	negated_boolean_value: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				token (Boolean_not_operator), boolean_value
			>>)
			Result.set_action_on_match_end (agent on_boolean_not_expression)
		end

	boolean_value: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				numeric_comparison_expression,
				variable_reference |to| agent on_boolean_variable
			>>)
		end

	boolean_expression: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			conjunction_plus_right_operand: EL_MATCH_ALL_IN_LIST_TP
		do
			conjunction_plus_right_operand := all_of (<<
				one_of (<< token (Boolean_and_operator), token (Boolean_or_operator) >>),
				simple_boolean_expression
			>>)
			conjunction_plus_right_operand.set_action_on_match_end (agent on_boolean_conjunction_expression)

			Result := all_of (<<
				simple_boolean_expression,
				optional (conjunction_plus_right_operand)
			>>)
		end

	constant_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				token (Quoted_string),
				token (Double_constant_token),
				token (Integer_64_constant_token)
			>>)
		end
feature {NONE} -- Actions

	on_variable_reference (tokens_matched: EL_STRING_VIEW)
			--
		local
			variable_subst_directive: EVOLICITY_VARIABLE_SUBST_DIRECTIVE
		do
--			log.enter ("on_variable_reference")
			create variable_subst_directive.make (tokens_to_variable_ref (tokens_matched))
			compound_directive.extend (variable_subst_directive)

--			variable_ref := tokens_to_variable_ref (tokens_matched)
--			if log.current_routine_is_active then
--				log.put_string ("$")
--				from i := 1 until i > variable_ref.count loop
--					if i > 1 then
--						log.put_string (".")
--					end
--  					log.put_string (variable_ref @ i)
--					i := i + 1
--				end
--			end
--			log.put_new_line
--			log.exit
		end

	on_free_text (tokens_matched: EL_STRING_VIEW)
			--
		local
			free_text_string: ASTRING
		do
--			log.enter ("on_free_text")
			free_text_string := source_text_for_token (1, tokens_matched)
--			log.put_string_field ("TEXT", free_text_string )
--			log.put_new_line
			compound_directive.extend (create {EVOLICITY_FREE_TEXT_DIRECTIVE}.make (free_text_string))
--			log.exit
		end

	on_dollor_sign_escape (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_dollor_sign_escape")
			if not compound_directive.is_empty
				and then attached {EVOLICITY_FREE_TEXT_DIRECTIVE} compound_directive.last as free_text_directive
			then
				free_text_directive.text.append_character ('$')
			else
				compound_directive.extend (create {EVOLICITY_FREE_TEXT_DIRECTIVE}.make ("$"))
			end
--			log.exit
		end

	on_loop_directive (tokens_matched: EL_STRING_VIEW; across_syntax: BOOLEAN)
			--
		do
--			log.enter ("on_loop_directive")
			compound_directive_stack.put (compound_directive)
			if across_syntax then
				loop_directive_stack.put (create {EVOLICITY_ACROSS_DIRECTIVE}.make)
			else
				loop_directive_stack.put (create {EVOLICITY_FOREACH_DIRECTIVE}.make)
			end
			compound_directive := loop_directive_stack.item
--			log.exit
		end

	on_loop_iterator (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_loop_iterator")
			loop_directive_stack.item.set_var_iterator (
				tokens_to_variable_ref (tokens_matched) @ 1
			)
--			log.exit
		end

	on_loop_traversable_container (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_loop_traversable_container")
			loop_directive_stack.item.set_traversable_container_variable_ref (
				tokens_to_variable_ref (tokens_matched)
			)
--			log.exit
		end

	on_loop_end (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_loop_end")
			compound_directive := compound_directive_stack.item
			compound_directive_stack.remove

			compound_directive.extend (loop_directive_stack.item)
			loop_directive_stack.remove
--			log.exit
		end

	on_evaluate (tokens_matched: EL_STRING_VIEW)
			--
		do
			create last_evaluate_directive.make
			compound_directive.extend (last_evaluate_directive)
		end

	on_evaluate_leading_space (tokens_matched: EL_STRING_VIEW)
			--
		do
			set_nested_directive_indent (last_evaluate_directive, tokens_matched)
		end

	on_evaluate_template_identifier (tokens_matched: EL_STRING_VIEW)
			--
		do
			last_evaluate_directive.set_template_name (source_text_for_token (1, tokens_matched))
		end

	on_evaluate_template_name_reference (tokens_matched: EL_STRING_VIEW)
			--
		do
			last_evaluate_directive.set_template_name_variable_ref (tokens_to_variable_ref (tokens_matched))
		end

	on_evaluate_variable_reference (tokens_matched: EL_STRING_VIEW)
			--
		do
			last_evaluate_directive.set_variable_ref (tokens_to_variable_ref (tokens_matched))
		end

	on_include (tokens_matched: EL_STRING_VIEW)
			--
		do
			create last_include_directive.make
			compound_directive.extend (last_include_directive)
		end

	on_include_leading_space (tokens_matched: EL_STRING_VIEW)
			--
		do
			set_nested_directive_indent (last_include_directive, tokens_matched)
		end

	on_include_variable_reference (tokens_matched: EL_STRING_VIEW)
			--
		do
			last_include_directive.set_variable_ref (tokens_to_variable_ref (tokens_matched))
		end

	on_if (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_if")
			compound_directive_stack.put (compound_directive)
			if_else_directive_stack.put (create {EVOLICITY_IF_ELSE_DIRECTIVE}.make)
			compound_directive := if_else_directive_stack.item
--			log.exit
		end

	on_if_then (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_if_then")
  			if_else_directive_stack.item.set_boolean_expression (boolean_expression_stack.item)
  			boolean_expression_stack.remove
--			log.exit
		end

	on_else (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_else")
			if_else_directive_stack.item.set_if_true_interval
--			log.exit
		end

	on_if_else_end (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_if_else_end")
			compound_directive := compound_directive_stack.item
			compound_directive_stack.remove

			if_else_directive_stack.item.set_if_false_interval
			compound_directive.extend (if_else_directive_stack.item)
			if_else_directive_stack.remove
--			log.exit
		end

	on_simple_comparison_expression (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_simple_comparison_expression")
--			log.exit
		end

	on_comparison_expression (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_comparison_expression")
  			numeric_comparison_stack.item.set_right_hand_expression (number_stack.item)
  			number_stack.remove
  			numeric_comparison_stack.item.set_left_hand_expression (number_stack.item)
  			number_stack.remove
  			boolean_expression_stack.put (numeric_comparison_stack.item)
  			numeric_comparison_stack.remove
--			log.exit
		end

	on_less_than_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_less_than_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_LESS_THAN_COMPARISON})
--			log.exit
		end

	on_greater_than_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_greater_than_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_GREATER_THAN_COMPARISON})
--			log.exit
		end

	on_equal_to_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_equal_to_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_EQUAL_TO_COMPARISON})
--			log.exit
		end

	on_comparison_variable_reference (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_comparison_variable_reference")
			number_stack.put (create {EVOLICITY_COMPARABLE_VARIABLE}.make (tokens_to_variable_ref (tokens_matched)))
--			log.exit
		end

	on_integer_64_comparison (tokens_matched: EL_STRING_VIEW)
			--
		require
			valid_text: source_text_for_token (1, tokens_matched).is_integer_64
		local
			comparable_integer: EVOLICITY_INTEGER_64_COMPARABLE
		do
--			log.enter ("on_integer_64_comparison")
  			create comparable_integer.make_from_string (source_text_for_token (1, tokens_matched))
  			number_stack.put (comparable_integer)
--			log.exit
		end

	on_double_comparison (tokens_matched: EL_STRING_VIEW)
			--
		require
			valid_text: source_text_for_token (1, tokens_matched).is_double
		local
			comparable_double: EVOLICITY_DOUBLE_COMPARABLE
		do
--			log.enter ("on_double_comparison")
			create comparable_double.make_from_string (source_text_for_token (1, tokens_matched))
  			number_stack.put (comparable_double)
--			log.exit
		end

	on_boolean_variable (tokens_matched: EL_STRING_VIEW)
			--
		local
			boolean_variable: EVOLICITY_BOOLEAN_REFERENCE_EXPRESSION
		do
--			log.enter ("on_boolean_variable")
			create boolean_variable.make (tokens_to_variable_ref (tokens_matched))
			boolean_expression_stack.put (boolean_variable)
--			log.exit
		end

	on_boolean_conjunction_expression (tokens_matched: EL_STRING_VIEW)
			--
		require
			boolean_expression_stack_has_two_expressions: boolean_expression_stack.count >= 2
		local
			boolean_conjunction_expression: EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION
		do
--			log.enter ("on_boolean_conjunction_expression")
			if tokens_matched.item (1) = Boolean_and_operator then
				create {EVOLICITY_BOOLEAN_AND_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
			else
				create {EVOLICITY_BOOLEAN_OR_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
			end
			boolean_expression_stack.remove
			boolean_conjunction_expression.set_left_hand_expression (boolean_expression_stack.item)
			boolean_expression_stack.remove
			boolean_expression_stack.put (boolean_conjunction_expression)
--			log.exit
		end

	on_boolean_not_expression (tokens_matched: EL_STRING_VIEW)
			--
		require
			boolean_expression_stack_not_empty: not boolean_expression_stack.is_empty
		local
			boolean_not: EVOLICITY_BOOLEAN_NOT_EXPRESSION
		do
--			log.enter ("boolean_not_expression")
			create boolean_not.make (boolean_expression_stack.item)
			boolean_expression_stack.remove
			boolean_expression_stack.put (boolean_not)
--			log.exit
		end

feature {NONE} -- Implementation

	reset_directives
		do
			create compound_directive.make
			create compound_directive_stack.make
			create loop_directive_stack.make
			create if_else_directive_stack.make
			create numeric_comparison_stack.make
			create boolean_expression_stack.make
			create number_stack.make
			create last_evaluate_directive.make
			create last_include_directive.make
		end

	set_nested_directive_indent (nested_directive: EVOLICITY_NESTED_TEMPLATE_DIRECTIVE; tokens_matched: EL_STRING_VIEW)
			--
		local
			leading_space: ASTRING
			space_count: INTEGER
		do
			leading_space := source_text_for_token (1, tokens_matched)
			if leading_space.occurrences ('%T') = leading_space.count then
				nested_directive.set_tab_indent (leading_space.count)
			else
				space_count := leading_space.occurrences (' ') + leading_space.occurrences ('%T') * Spaces_per_tab
				nested_directive.set_tab_indent (space_count // Spaces_per_tab)
			end
		end

	tokens_to_variable_ref (tokens_matched: EL_STRING_VIEW): EVOLICITY_VARIABLE_REFERENCE
			--
		local
			i: INTEGER
		do
--			log.enter ("tokens_to_variable_ref")
			create Result.make (tokens_matched.occurrences (Unqualified_name))
			from i := 1 until i > tokens_matched.count or else tokens_matched.item (i) = Left_bracket loop
				if tokens_matched.item (i) = Unqualified_name then
					Result.extend (source_text_for_token (i, tokens_matched))
				end
				i := i + 1
			end
			if i < tokens_matched.count and then tokens_matched.item (i) = Left_bracket then
				create {EVOLICITY_FUNCTION_REFERENCE} Result.make (Result.to_array, function_arguments (i, tokens_matched))
			end
--			log.exit
		ensure
			reference_contain_all_steps: Result.full
		end

	function_arguments (position: INTEGER; tokens_matched: EL_STRING_VIEW): ARRAY [ANY]
		require
			start_position_is_left_bracket: tokens_matched.item (position) = Left_bracket
		local
			i: INTEGER; i_th_token: NATURAL_32
			string_argument: ASTRING
			l_result: ARRAYED_LIST [ANY]
		do
			create l_result.make (2)
			from i := position + 1 until i > tokens_matched.count loop
				i_th_token := tokens_matched.item (i)
				if i_th_token = Quoted_string then
					string_argument := source_text_for_token (i, tokens_matched)
					String.remove_double_quote (string_argument)
					l_result.extend (string_argument)

				elseif i_th_token = Double_constant_token then
					l_result.extend (source_text_for_token (i, tokens_matched).to_double)

				elseif i_th_token = Integer_64_constant_token then
					l_result.extend (source_text_for_token (i, tokens_matched).to_integer_64)

				end
				i := i + 1
			end
			Result := l_result.to_array
		end

	compound_directive: EVOLICITY_COMPOUND_DIRECTIVE

	compound_directive_stack: LINKED_STACK [EVOLICITY_COMPOUND_DIRECTIVE]

	loop_directive_stack: LINKED_STACK [EVOLICITY_FOREACH_DIRECTIVE]

	if_else_directive_stack: LINKED_STACK [EVOLICITY_IF_ELSE_DIRECTIVE]

	numeric_comparison_stack: LINKED_STACK [EVOLICITY_COMPARISON]

	boolean_expression_stack: LINKED_STACK [EVOLICITY_BOOLEAN_EXPRESSION]

	number_stack: LINKED_STACK [EVOLICITY_COMPARABLE]

	last_evaluate_directive: EVOLICITY_EVALUATE_DIRECTIVE

	last_include_directive: EVOLICITY_INCLUDE_DIRECTIVE

feature {NONE} -- Constants

	Spaces_per_tab: INTEGER = 4

end -- class EVOLICITY_PARSER
