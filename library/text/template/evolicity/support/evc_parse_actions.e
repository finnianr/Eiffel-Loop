note
	description: "Evolicity parse actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 9:00:16 GMT (Thursday 20th March 2025)"
	revision: "16"

deferred class
	EVC_PARSE_ACTIONS

inherit
	EVC_SHARED_TOKEN_ENUM

	EL_TOKEN_TEXT_I
		export
			{EVC_VARIABLE_REFERENCE} all
		end

feature {NONE} -- Initialization

	make
		do
			create compound_directive.make
			create compound_directive_stack.make
			create loop_directive_stack.make
			create if_else_directive_stack.make
			create comparison_stack.make
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
			boolean_conjunction_expression: EVC_BOOLEAN_CONJUNCTION_EXPRESSION
		do
			if tokens_text.code (start_index) = Token.keyword_and then
				create {EVC_BOOLEAN_AND_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
			else
				create {EVC_BOOLEAN_OR_EXPRESSION} boolean_conjunction_expression.make (boolean_expression_stack.item)
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
			boolean_not: EVC_BOOLEAN_NOT_EXPRESSION
		do
			create boolean_not.make (boolean_expression_stack.item)
			boolean_expression_stack.remove
			boolean_expression_stack.put (boolean_not)
		end

	on_boolean_variable (start_index, end_index: INTEGER)
			--
		local
			boolean_variable: EVC_BOOLEAN_REFERENCE_EXPRESSION
		do
			create boolean_variable.make (new_variable_reference (start_index, end_index))
			boolean_expression_stack.put (boolean_variable)
		end

	on_comparable (type: NATURAL; start_index, end_index: INTEGER)
			--
		require
			valid_comparison_text: valid_comparison_text (type, start_index, end_index)
		local
			comparable: EVC_COMPARABLE
		do
			if type = Token.literal_integer then
	  			create comparable.make (token_integer_64 (start_index).to_reference)

			elseif type = Token.literal_real then
	  			create comparable.make (token_real_64 (start_index).to_reference)

			elseif type = Token.literal_string then
	  			if is_token_text_latin_1 (start_index) then
		  			create comparable.make (shared_token_text_8 (start_index, True))
		  		else
		  			create comparable.make (unquoted_token_text (start_index))
	  			end
			else
				create {EVC_COMPARABLE_VARIABLE} comparable.make (new_variable_reference (start_index, end_index))
			end
			number_stack.put (comparable)
		end

	on_comparison_expression (start_index, end_index: INTEGER)
			--
		do
			comparison_stack.item.set_right_hand_expression (number_stack.item)
			number_stack.remove
			comparison_stack.item.set_left_hand_expression (number_stack.item)
			number_stack.remove
			boolean_expression_stack.put (comparison_stack.item)
			comparison_stack.remove
		end

	on_dollor_sign_escape (start_index, end_index: INTEGER)
			--
		do
			if not compound_directive.is_empty
				and then attached {EVC_FREE_TEXT_DIRECTIVE} compound_directive.last as free_text_directive
			then
				free_text_directive.text.append_character ('$')
			else
				compound_directive.extend (create {EVC_FREE_TEXT_DIRECTIVE}.make ("$"))
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
				last_evaluate_directive.set_template_name (token_text (start_index))

			elseif id = Token.Literal_string then
				last_evaluate_directive.set_template_name (unquoted_token_text (start_index))

			elseif id = Token.operator_dot then
				last_evaluate_directive.set_template_name_variable_ref (new_variable_reference (start_index, end_index))
			else
				last_evaluate_directive.set_variable_ref (new_variable_reference (start_index, end_index))
			end
		end

	on_free_text (start_index, end_index: INTEGER)
			--
		local
			free_text_string: ZSTRING
		do
			free_text_string := token_text (start_index)
			compound_directive.extend (create {EVC_FREE_TEXT_DIRECTIVE}.make (free_text_string))
		end

	on_if (id: NATURAL; start_index, end_index: INTEGER)
			--
		do
			if id = Token.Keyword_if then
				compound_directive_stack.put (compound_directive)
				if_else_directive_stack.put (create {EVC_IF_ELSE_DIRECTIVE}.make)
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

			elseif id = Token.Literal_string then
				last_include_directive.set_template_name (unquoted_token_text (start_index))

			elseif id = Token.operator_dot then
				last_include_directive.set_variable_ref (new_variable_reference (start_index, end_index))
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
				loop_directive_stack.item.set_iterable_variable_ref (new_variable_reference (start_index, end_index))

			elseif id = Token.keyword_as then
				loop_directive_stack.item.put_item_name (new_variable_reference (start_index, end_index) @ 1)

			elseif id  = Token.keyword_end then
				compound_directive := compound_directive_stack.item
				compound_directive_stack.remove

				compound_directive.extend (loop_directive_stack.item)
				loop_directive_stack.remove
			end
		end

	on_comparison (symbol: CHARACTER; start_index, end_index: INTEGER)
			--
		local
			comparison: EVC_COMPARISON
		do
			inspect symbol
				when '<' then
		  			create {EVC_LESS_THAN_COMPARISON} comparison
		  		when '>' then
		  			create {EVC_GREATER_THAN_COMPARISON} comparison
		  		when '=' then
					create {EVC_EQUAL_TO_COMPARISON} comparison
		  		when '/' then
					create {EVC_NOT_EQUAL_TO_COMPARISON} comparison
			else
				create {EVC_EQUAL_TO_COMPARISON} comparison
			end
			comparison_stack.put (comparison)
		end

	on_simple_comparison_expression (start_index, end_index: INTEGER)
			--
		do
		end

	on_value_reference (start_index, end_index: INTEGER)
		local
			substitution: EVC_VARIABLE_SUBST_DIRECTIVE
		do
			create substitution.make (new_variable_reference (start_index, end_index))
			compound_directive.extend (substitution)
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

	comparison_action (symbol: CHARACTER): PROCEDURE [INTEGER, INTEGER]
		do
			Result := agent on_comparison (symbol, ?, ?)
		end

feature {NONE} -- Factory

	new_loop_directive (id: NATURAL): EVC_FOREACH_DIRECTIVE
		do
			if id = Token.Keyword_across then
				create {EVC_ACROSS_DIRECTIVE} Result.make
			else
				create Result.make
			end
		end

	new_variable_reference (start_index, end_index: INTEGER): EVC_VARIABLE_REFERENCE
			--
		do
			if tokens_text.code (start_index) = Token.at_sign then
				create {EVC_FUNCTION_REFERENCE} Result.make (Current, start_index, end_index)
			else
				create Result.make (Current, start_index, end_index)
			end
		ensure
			correct_capacity: Result.full
		end

feature {NONE} -- Implementation

	set_nested_directive_indent (nested_directive: EVC_NESTED_TEMPLATE_DIRECTIVE; start_index, end_index: INTEGER)
			--
		local
			leading_space: ZSTRING; space_count: INTEGER
		do
			leading_space := token_text (start_index)
			if leading_space.occurrences ('%T') = leading_space.count then
				nested_directive.set_tab_indent (leading_space.count)
			else
				space_count := leading_space.occurrences (' ') + leading_space.occurrences ('%T') * Spaces_per_tab
				nested_directive.set_tab_indent (space_count // Spaces_per_tab)
			end
		end

	tokens_out (start_index, end_index: INTEGER): SPECIAL [READABLE_STRING_GENERAL]
		-- For use as a watch expression in the Studio debugger
		local
			i: INTEGER; i_th_token: NATURAL_32
		do
			create Result.make_empty (end_index - start_index + 1)
			from i := start_index until i > end_index loop
				i_th_token := tokens_text.code (i)

				if Token.valid_value (i_th_token) then
					Result.extend (Token.name (i_th_token))

				elseif attached token_text (i) as text then
					if text.is_valid_as_string_8 then
						Result.extend (text.to_string_8)
					else
						Result.extend (text.to_string_32)
					end
				end
				i := i + 1
			end
		end

	valid_comparison_text (type: NATURAL; start_index, end_index: INTEGER): BOOLEAN
		do
			if type = Token.Literal_integer then
	  			Result := token_text (start_index).is_integer_64

			elseif type = Token.literal_real then
	  			Result := token_text (start_index).is_real_64

	  		else
	  			Result := True
			end
		end

feature {NONE} -- Internal attributes

	boolean_expression_stack: LINKED_STACK [EVC_BOOLEAN_EXPRESSION]

	compound_directive: EVC_COMPOUND_DIRECTIVE

	compound_directive_stack: LINKED_STACK [EVC_COMPOUND_DIRECTIVE]

	if_else_directive_stack: LINKED_STACK [EVC_IF_ELSE_DIRECTIVE]

	last_evaluate_directive: EVC_EVALUATE_DIRECTIVE

	last_include_directive: EVC_INCLUDE_DIRECTIVE

	loop_directive_stack: LINKED_STACK [EVC_FOREACH_DIRECTIVE]

	number_stack: LINKED_STACK [EVC_COMPARABLE]

	comparison_stack: LINKED_STACK [EVC_COMPARISON]

feature {NONE} -- Constants

	Spaces_per_tab: INTEGER = 4

end