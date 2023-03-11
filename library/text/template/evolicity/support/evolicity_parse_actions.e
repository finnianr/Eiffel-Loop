note
	description: "Evolicity parse actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:56 GMT (Friday 10th March 2023)"
	revision: "10"

deferred class
	EVOLICITY_PARSE_ACTIONS

inherit
	EVOLICITY_SHARED_TOKEN_ENUM

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

	on_boolean_conjunction_expression (start_index, end_index: INTEGER)
			--
		require
			boolean_expression_stack_has_two_expressions: boolean_expression_stack.count >= 2
		local
			boolean_conjunction_expression: EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION
		do
			if tokens_text.code (start_index) = Token.keyword_and then
				create {EVOLICITY_BOOLEAN_AND_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
			else
				create {EVOLICITY_BOOLEAN_OR_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
			end
			boolean_expression_stack.remove
			boolean_conjunction_expression.set_left_hand_expression (boolean_expression_stack.item)
			boolean_expression_stack.remove
			boolean_expression_stack.put (boolean_conjunction_expression)
		end

	on_boolean_not_expression (start_index, end_index: INTEGER)
			--
		require
			boolean_expression_stack_not_empty: not boolean_expression_stack.is_empty
		local
			boolean_not: EVOLICITY_BOOLEAN_NOT_EXPRESSION
		do
			create boolean_not.make (boolean_expression_stack.item)
			boolean_expression_stack.remove
			boolean_expression_stack.put (boolean_not)
		end

	on_boolean_variable (start_index, end_index: INTEGER)
			--
		local
			boolean_variable: EVOLICITY_BOOLEAN_REFERENCE_EXPRESSION
		do
			create boolean_variable.make (tokens_to_variable_ref (start_index, end_index))
			boolean_expression_stack.put (boolean_variable)
		end

	on_comparable (type: NATURAL; start_index, end_index: INTEGER)
			--
		require
			valid_comparison_text: valid_comparison_text (type, start_index, end_index)
		local
			comparable: EVOLICITY_COMPARABLE; str: ZSTRING
		do
				if type = Token.integer_64_constant then
				str := source_text_for_token (start_index)
	  			create {EVOLICITY_INTEGER_64_COMPARABLE} comparable.make_from_string (str)

				elseif type = Token.double_constant then
				str := source_text_for_token (start_index)
				create {EVOLICITY_DOUBLE_COMPARABLE} comparable.make_from_string (str)
			else
				create {EVOLICITY_COMPARABLE_VARIABLE} comparable.make (tokens_to_variable_ref (start_index, end_index))
				end
				number_stack.put (comparable)
		end

	on_comparison_expression (start_index, end_index: INTEGER)
			--
		do
				numeric_comparison_stack.item.set_right_hand_expression (number_stack.item)
				number_stack.remove
				numeric_comparison_stack.item.set_left_hand_expression (number_stack.item)
				number_stack.remove
				boolean_expression_stack.put (numeric_comparison_stack.item)
				numeric_comparison_stack.remove
		end

	on_dollor_sign_escape (start_index, end_index: INTEGER)
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

	on_evaluate (id: NATURAL; start_index, end_index: INTEGER)
			--
		do
			if id = Token.Keyword_evaluate then
				create last_evaluate_directive.make
				compound_directive.extend (last_evaluate_directive)

			elseif id = Token.White_text then
				--	leading space
				set_nested_directive_indent (last_evaluate_directive, start_index, end_index)

			elseif id = Token.Template_name_identifier then
				last_evaluate_directive.set_template_name (source_text_for_token (start_index))

			elseif id = Token.Quoted_string then
				if attached source_text_for_token (start_index) as str then
					str.remove_quotes
					last_evaluate_directive.set_template_name (str)
				end
			elseif id = Token.operator_dot then
				last_evaluate_directive.set_template_name_variable_ref (tokens_to_variable_ref (start_index, end_index))
			else
				last_evaluate_directive.set_variable_ref (tokens_to_variable_ref (start_index, end_index))
			end
		end

	on_free_text (start_index, end_index: INTEGER)
			--
		local
			free_text_string: ZSTRING
		do
			free_text_string := source_text_for_token (start_index)
			compound_directive.extend (create {EVOLICITY_FREE_TEXT_DIRECTIVE}.make (free_text_string))
		end

	on_if (id: NATURAL; start_index, end_index: INTEGER)
			--
		do
			if id = Token.Keyword_if then
				compound_directive_stack.put (compound_directive)
				if_else_directive_stack.put (create {EVOLICITY_IF_ELSE_DIRECTIVE}.make)
				compound_directive := if_else_directive_stack.item

			elseif id = Token.Keyword_then then
	  			if_else_directive_stack.item.set_boolean_expression (boolean_expression_stack.item)
	  			boolean_expression_stack.remove

	  		elseif id = Token.Keyword_else then
				if_else_directive_stack.item.set_if_true_interval

			elseif id = Token.Keyword_end then
				compound_directive := compound_directive_stack.item
				compound_directive_stack.remove

				if_else_directive_stack.item.set_if_false_interval
				compound_directive.extend (if_else_directive_stack.item)
				if_else_directive_stack.remove
			end
		end

	on_include (id: NATURAL; start_index, end_index: INTEGER)
			--
		do
			if id = Token.Keyword_include then
				create last_include_directive.make
				compound_directive.extend (last_include_directive)

			elseif id = Token.White_text then
				-- leading space
				set_nested_directive_indent (last_include_directive, start_index, end_index)

			elseif id = Token.Quoted_string then
				if attached source_text_for_token (start_index) as str then
					str.remove_quotes
					last_include_directive.set_template_name (str)
				end

			elseif id = Token.operator_dot then
				last_include_directive.set_variable_ref (tokens_to_variable_ref (start_index, end_index))
			end
		end

	on_loop (id: NATURAL; start_index, end_index: INTEGER)
			--
		do
			if Token.loop_keywords.has (id) then
				compound_directive_stack.put (compound_directive)
				loop_directive_stack.put (new_loop_directive (id))
				compound_directive := loop_directive_stack.item

			elseif id = Token.keyword_in then
				loop_directive_stack.item.set_iterable_variable_ref (tokens_to_variable_ref (start_index, end_index))

			elseif id = Token.keyword_as then
				loop_directive_stack.item.put_item_name (tokens_to_variable_ref (start_index, end_index) @ 1)

			elseif id  = Token.keyword_end then
				compound_directive := compound_directive_stack.item
				compound_directive_stack.remove

				compound_directive.extend (loop_directive_stack.item)
				loop_directive_stack.remove
			end
		end

	on_numeric_comparison (symbol: CHARACTER; start_index, end_index: INTEGER)
			--
		local
			comparison: EVOLICITY_COMPARISON
		do
			inspect symbol
				when '<' then
		  			create {EVOLICITY_LESS_THAN_COMPARISON} comparison
		  		when '>' then
		  			create {EVOLICITY_GREATER_THAN_COMPARISON} comparison
		  		when '=' then
					create {EVOLICITY_EQUAL_TO_COMPARISON} comparison
			else
				create {EVOLICITY_EQUAL_TO_COMPARISON} comparison
			end
			numeric_comparison_stack.put (comparison)
		end

	on_simple_comparison_expression (start_index, end_index: INTEGER)
			--
		do
		end

	on_variable_reference (start_index, end_index: INTEGER)
			--
		local
			variable_subst_directive: EVOLICITY_VARIABLE_SUBST_DIRECTIVE
		do
--			log.enter ("on_variable_reference")
			create variable_subst_directive.make (tokens_to_variable_ref (start_index, end_index))
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

feature {NONE} -- Parse actions

	comparable_action (id: NATURAL): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_comparable (id, ?, ?)
		end

	evaluate_action (id: NATURAL): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_evaluate (id, ?, ?)
		end

	if_action (id: NATURAL): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_if (id, ?, ?)
		end

	include_action (id: NATURAL): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_include (id, ?, ?)
		end

	loop_action (id: NATURAL): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_loop (id, ?, ?)
		end

	numeric_comparison_action (symbol: CHARACTER): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_numeric_comparison (symbol, ?, ?)
		end

feature {NONE} -- Implementation

	function_arguments (position: INTEGER; end_index: INTEGER): TUPLE
		require
			start_position_is_left_bracket: tokens_text.code (position) = Token.Left_bracket
		local
			i: INTEGER; i_th_token: NATURAL_32; string_arg: ZSTRING
			buffer: like Argument_buffer
		do
			buffer := Argument_buffer
			buffer.wipe_out
			from i := position + 1 until i > end_index loop
				i_th_token := tokens_text.code (i)
				if i_th_token = Token.Quoted_string then
					string_arg := source_text_for_token (i)
					string_arg.remove_quotes
					buffer.extend (string_arg)

				elseif i_th_token = Token.double_constant then
					buffer.extend (source_text_for_token (i).to_double)

				elseif i_th_token = Token.integer_64_constant then
					buffer.extend (source_text_for_token (i).to_integer_64)

				end
				i := i + 1
			end
			Result := buffer.to_tuple
		end

	new_loop_directive (id: NATURAL): EVOLICITY_FOREACH_DIRECTIVE
		do
			if id = Token.Keyword_across then
				create {EVOLICITY_ACROSS_DIRECTIVE} Result.make
			else
				create Result.make
			end
		end

	set_nested_directive_indent (nested_directive: EVOLICITY_NESTED_TEMPLATE_DIRECTIVE; start_index, end_index: INTEGER)
			--
		local
			leading_space: ZSTRING; space_count: INTEGER
		do
			leading_space := source_text_for_token (start_index)
			if leading_space.occurrences ('%T') = leading_space.count then
				nested_directive.set_tab_indent (leading_space.count)
			else
				space_count := leading_space.occurrences (' ') + leading_space.occurrences ('%T') * Spaces_per_tab
				nested_directive.set_tab_indent (space_count // Spaces_per_tab)
			end
		end

	tokens_to_variable_ref (start_index, end_index: INTEGER): EVOLICITY_VARIABLE_REFERENCE
			--
		local
			i: INTEGER
		do
			create Result.make (token_occurrences (Token.Unqualified_name, start_index, end_index))
			from i := start_index until i > end_index or else tokens_text.code (i) = Token.Left_bracket loop
				if tokens_text.code (i) = Token.Unqualified_name then
					Result.extend (source_text_for_token (i))
				end
				i := i + 1
			end
			if i < end_index and then tokens_text.code (i) = Token.Left_bracket
				and then attached function_arguments (i, end_index) as args
			then
				create {EVOLICITY_FUNCTION_REFERENCE} Result.make (Result.to_array, args)
			end
		ensure
			reference_contain_all_steps: Result.full
		end

	valid_comparison_text (type: NATURAL; start_index, end_index: INTEGER): BOOLEAN
		do
				if type = Token.integer_64_constant then
	  			Result := source_text_for_token (start_index).is_integer_64

				elseif type = Token.double_constant then
	  			Result := source_text_for_token (start_index).is_double
	  		else
	  			Result := True
				end
		end

feature {NONE} -- Deferred

	tokens_text: STRING_32
		deferred
		end

	source_text_for_token (i: INTEGER): ZSTRING
		deferred
		end

	token_occurrences (a_token: NATURAL; start_index, end_index: INTEGER): INTEGER
		deferred
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