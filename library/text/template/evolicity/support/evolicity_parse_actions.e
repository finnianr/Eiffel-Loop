note
	description: "Evolicity parse actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:23:02 GMT (Sunday 19th December 2021)"
	revision: "2"

deferred class
	EVOLICITY_PARSE_ACTIONS

inherit
	EVOLICITY_TOKENS

feature {NONE} -- Initialization

	make
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

feature {NONE} -- Actions

	on_boolean_conjunction_expression (tokens_matched: EL_STRING_VIEW)
			--
		require
			boolean_expression_stack_has_two_expressions: boolean_expression_stack.count >= 2
		local
			boolean_conjunction_expression: EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION
		do
--			log.enter ("on_boolean_conjunction_expression")
			if tokens_matched.code (1) = Boolean_and_operator then
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

	on_comparison_variable_reference (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_comparison_variable_reference")
			number_stack.put (create {EVOLICITY_COMPARABLE_VARIABLE}.make (tokens_to_variable_ref (tokens_matched)))
--			log.exit
		end

	on_dollor_sign_escape (tokens_matched: EL_STRING_VIEW)
			--
		do
			if not compound_directive.is_empty
				and then attached {EVOLICITY_FREE_TEXT_DIRECTIVE} compound_directive.last as free_text_directive
			then
				free_text_directive.text.append_character ('$')
			else
				compound_directive.extend (create {EVOLICITY_FREE_TEXT_DIRECTIVE}.make ("$"))
			end
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

	on_else (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_else")
			if_else_directive_stack.item.set_if_true_interval
--			log.exit
		end

	on_equal_to_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_equal_to_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_EQUAL_TO_COMPARISON})
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

	on_free_text (tokens_matched: EL_STRING_VIEW)
			--
		local
			free_text_string: ZSTRING
		do
--			log.enter ("on_free_text")
			free_text_string := source_text_for_token (1, tokens_matched)
--			log.put_string_field ("TEXT", free_text_string )
--			log.put_new_line
			compound_directive.extend (create {EVOLICITY_FREE_TEXT_DIRECTIVE}.make (free_text_string))
--			log.exit
		end

	on_greater_than_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_greater_than_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_GREATER_THAN_COMPARISON})
--			log.exit
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

	on_if_then (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_if_then")
  			if_else_directive_stack.item.set_boolean_expression (boolean_expression_stack.item)
  			boolean_expression_stack.remove
--			log.exit
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

	on_less_than_numeric_comparison (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_less_than_numeric_comparison")
  			numeric_comparison_stack.put (create {EVOLICITY_LESS_THAN_COMPARISON})
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

	on_simple_comparison_expression (tokens_matched: EL_STRING_VIEW)
			--
		do
--			log.enter ("on_simple_comparison_expression")
--			log.exit
		end

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

feature {NONE} -- Implementation

	function_arguments (position: INTEGER; tokens_matched: EL_STRING_VIEW): TUPLE
		require
			start_position_is_left_bracket: tokens_matched.code (position) = Left_bracket
		local
			i: INTEGER; i_th_token: NATURAL_32; string_arg: ZSTRING
			buffer: like Argument_buffer
		do
			buffer := Argument_buffer
			buffer.wipe_out
			from i := position + 1 until i > tokens_matched.count loop
				i_th_token := tokens_matched.code (i)
				if i_th_token = Quoted_string then
					string_arg := source_text_for_token (i, tokens_matched)
					string_arg.remove_quotes
					buffer.extend (string_arg)

				elseif i_th_token = Double_constant_token then
					buffer.extend (source_text_for_token (i, tokens_matched).to_double)

				elseif i_th_token = Integer_64_constant_token then
					buffer.extend (source_text_for_token (i, tokens_matched).to_integer_64)

				end
				i := i + 1
			end
			Result := buffer.to_tuple
		end

	set_nested_directive_indent (nested_directive: EVOLICITY_NESTED_TEMPLATE_DIRECTIVE; tokens_matched: EL_STRING_VIEW)
			--
		local
			leading_space: ZSTRING; space_count: INTEGER
		do
			leading_space := source_text_for_token (1, tokens_matched)
			if leading_space.occurrences ('%T') = leading_space.count then
				nested_directive.set_tab_indent (leading_space.count)
			else
				space_count := leading_space.occurrences (' ') + leading_space.occurrences ('%T') * Spaces_per_tab
				nested_directive.set_tab_indent (space_count // Spaces_per_tab)
			end
		end

	source_text_for_token (i: INTEGER; matched_tokens: EL_STRING_VIEW): ZSTRING
		deferred
		end

	tokens_to_variable_ref (tokens_matched: EL_STRING_VIEW): EVOLICITY_VARIABLE_REFERENCE
			--
		local
			i: INTEGER
		do
--			log.enter ("tokens_to_variable_ref")
			create Result.make (tokens_matched.occurrences (Unqualified_name))
			from i := 1 until i > tokens_matched.count or else tokens_matched.code (i) = Left_bracket loop
				if tokens_matched.code (i) = Unqualified_name then
					Result.extend (source_text_for_token (i, tokens_matched))
				end
				i := i + 1
			end
			if i < tokens_matched.count and then tokens_matched.code (i) = Left_bracket then
				create {EVOLICITY_FUNCTION_REFERENCE} Result.make (Result.to_array, function_arguments (i, tokens_matched))
			end
--			log.exit
		ensure
			reference_contain_all_steps: Result.full
		end

feature {NONE} -- Internal attributes

	boolean_expression_stack: LINKED_STACK [EVOLICITY_BOOLEAN_EXPRESSION]

	compound_directive: EVOLICITY_COMPOUND_DIRECTIVE

	compound_directive_stack: LINKED_STACK [EVOLICITY_COMPOUND_DIRECTIVE]

	if_else_directive_stack: LINKED_STACK [EVOLICITY_IF_ELSE_DIRECTIVE]

	last_evaluate_directive: EVOLICITY_EVALUATE_DIRECTIVE

	last_include_directive: EVOLICITY_INCLUDE_DIRECTIVE

	loop_directive_stack: LINKED_STACK [EVOLICITY_FOREACH_DIRECTIVE]

	number_stack: LINKED_STACK [EVOLICITY_COMPARABLE]

	numeric_comparison_stack: LINKED_STACK [EVOLICITY_COMPARISON]

feature {NONE} -- Constants

	Argument_buffer: EL_ARRAYED_LIST [ANY]
		once
			create Result.make (3)
		end

	Spaces_per_tab: INTEGER = 4

end