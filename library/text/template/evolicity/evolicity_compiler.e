note
	description: "Evolicity compiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-17 13:48:14 GMT (Sunday 17th January 2021)"
	revision: "12"

class
	EVOLICITY_COMPILER

inherit
	EL_TOKEN_PARSER [EVOLICITY_FILE_LEXER]
		rename
			match_full as parse,
			parse as parse_and_compile,
			fully_matched as parse_succeeded,
			call_actions as compile
		redefine
			set_source_text_from_file, set_source_text_from_line_source, tokens_text
		end

	EVOLICITY_PARSE_ACTIONS
		rename
			make as reset_directives
		end

	EL_TEXT_PATTERN_FACTORY
		rename
			quoted_string as quoted_string_pattern
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_BUILD_INFO

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create modification_time.make_from_epoch (0)
			reset_directives
			encoding := 0 -- indicates a text source by default
		end

feature -- Access

	compiled_template: EVOLICITY_COMPILED_TEMPLATE
		do
			reset_directives
			compile
			create Result.make (compound_directive.to_array, modification_time, Current)
			Result.set_minimum_buffer_length ((source_view.full_count * 1.5).floor)
		end

	modification_time: DATE_TIME

feature -- Element change

 	set_source_text_from_file (file_path: EL_FILE_PATH)
 		require else
 			valid_encoding_set: valid_encoding (encoding_type | encoding_id)
		do
			modification_time := file_path.modification_date_time
			Precursor (file_path)
		end

	set_source_text_from_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
			--
		local
			compiled_source_path: like source_file_path
		do
 			source_file_path := lines.file_path
 			set_encoding_from_other (lines) -- May have detected UTF-8 BOM

			compiled_source_path := source_file_path.with_new_extension ("evc")
			if compiled_source_path.exists
				and then same_software_version (compiled_source_path)
				and then compiled_source_path.modification_date_time > source_file_path.modification_date_time
			then
				read_tokens_text (compiled_source_path)
				tokens_view := pattern.new_text_view (tokens_text)
				source_view := pattern.new_text_view (lines.joined)
	 			reset
			else
	 			set_source_text (lines.joined)
	 			-- Check write permission
				if compiled_source_path.parent.exists_and_is_writeable then
					write_tokens_text (compiled_source_path)
				end
			end
		end

feature {NONE} -- Directives

	across_directive: like all_of
			--
		do
			Result := all_of (<<
				token (Keyword_across)		|to| agent on_loop_directive (?, True),
				variable_reference 			|to| agent on_loop_traversable_container,
				token (Keyword_as),
				variable_reference			|to| agent on_loop_iterator,
				token (Keyword_loop),
				recurse (agent zero_or_more_directives, True),
				token (Keyword_end)			|to| agent on_loop_end
			>> )
		end

	control_directive: like one_of
			--
		do
			Result := one_of (<< foreach_directive, across_directive, if_else_end_directive >> )
		end

	directive: like one_of
			--
		do
			Result := one_of (
				<< token (Free_text)				|to| agent on_free_text,
					token (Double_dollor_sign) |to| agent on_dollor_sign_escape,
					variable_reference 			|to| agent on_variable_reference,
					evaluate_directive,
					include_directive,
					control_directive
				>>
			)
		end

	else_directive: like all_of
			--
		do
			Result := all_of (<<
				token (Keyword_else),
				recurse (agent zero_or_more_directives, True)
			>> )
		end

	evaluate_directive: like all_of
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

	foreach_directive: like all_of
			-- Match: foreach ( V in V )
		do
			Result := all_of (<<
				token (Keyword_foreach)		|to| agent on_loop_directive (?, False),
				variable_reference			|to| agent on_loop_iterator,
				token (Keyword_in),
				variable_reference 			|to| agent on_loop_traversable_container,
				token (Keyword_loop),
				recurse (agent zero_or_more_directives, True),
				token (Keyword_end)			|to| agent on_loop_end
			>> )
		end

	if_else_end_directive: like all_of
			--
		do
			Result := all_of (<<
				token (Keyword_if) 			|to| agent on_if,
				boolean_expression,
				token (Keyword_then) 		|to| agent on_if_then,
				recurse (agent zero_or_more_directives, True),
				optional (else_directive)	|to| agent on_else,
				token (Keyword_end) 			|to| agent on_if_else_end
			>> )
		end

	include_directive: like all_of
			--
		do
			Result := all_of (<<
				token (Keyword_include)		|to| agent on_include,
				token (White_text)			|to| agent on_include_leading_space,
				variable_reference 			|to| agent on_include_variable_reference
			>> )
		end

	new_pattern: like one_or_more
			--
		do
			Result := one_or_more (directive)
		end

	zero_or_more_directives: like zero_or_more
		do
			Result := zero_or_more (directive)
		end

feature {NONE} -- Expresssions

	boolean_expression: like all_of
			--
		local
			conjunction_plus_right_operand: like all_of
		do
			conjunction_plus_right_operand := all_of (<<
				one_of (<< token (Boolean_and_operator), token (Boolean_or_operator) >>),
				simple_boolean_expression
			>>)
			conjunction_plus_right_operand.set_action_last (agent on_boolean_conjunction_expression)

			Result := all_of (<<
				simple_boolean_expression, optional (conjunction_plus_right_operand)
			>>)
		end

	boolean_value: like one_of
			--
		do
			Result := one_of (<<
				numeric_comparison_expression,
				variable_reference |to| agent on_boolean_variable
			>>)
		end

	constant_pattern: like one_of
			--
		do
			Result := one_of (<<
				token (Quoted_string),
				token (Double_constant_token),
				token (Integer_64_constant_token)
			>>)
		end

	function_call: like all_of
		do
			Result := all_of (<<
				token (Left_bracket),
				constant_pattern,
				while_not_p1_repeat_p2 (
					token (Right_bracket),
					all_of (<<
						token (Comma_sign),
						constant_pattern
					>>)
				)
			>>)
		end

--	type_comparison_expression: like all_of is
--			--
--		do
--			Result := all_of ( <<
--				variable_reference,
--				token (Is_type_of_operator),
--				token (Class_name_identifier)
--			>>)
--		end
--
	negated_boolean_value: like all_of
			--
		do
			Result := all_of (<<
				token (Boolean_not_operator), boolean_value
			>>)
			Result.set_action_last (agent on_boolean_not_expression)
		end

	numeric_comparison_expression: like all_of
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
			Result.set_action_last (agent on_comparison_expression)
		end

	numeric_comparison_operator: like all_of
			--
		do
			Result := one_of ( <<
				token (Less_than_operator) 	|to| agent on_less_than_numeric_comparison,
				token (Greater_than_operator) |to| agent on_greater_than_numeric_comparison,
				token (Equal_to_operator) 		|to| agent on_equal_to_numeric_comparison,
				token (Not_equal_to_operator)
			>>)
		end

	simple_boolean_expression: like one_of
			--
		do
			Result := one_of (<<
				negated_boolean_value, boolean_value
			>>)
		end

	variable_reference: like all_of
			--
		do
			Result := all_of (<<
				token (Unqualified_name),
				zero_or_more (
					all_of (<< token (Dot_operator), token (Unqualified_name) >> )
				),
				optional (function_call)
			>>)
		end

feature {NONE} -- Implementation

	read_tokens_text (compiled_source_path: like source_file_path)
		local
			l_tokens_text: like tokens_text; l_token_text_array: like token_text_array
			i, count: INTEGER
		do
			if attached open_raw (compiled_source_path, Read) as compiled_source then
				-- skip software version
				compiled_source.move ({PLATFORM}.Natural_32_bytes)

				compiled_source.read_integer
				count := compiled_source.last_integer
				create tokens_text.make (count)
				l_tokens_text := tokens_text
				from i := 1 until i > count loop
					compiled_source.read_natural
					l_tokens_text.append_code (compiled_source.last_natural)
					i := i + 1
				end

				compiled_source.read_integer
				count := compiled_source.last_integer
				token_text_array.grow (count)
				l_token_text_array := token_text_array
				from i := 1 until i > count loop
					compiled_source.read_integer_64
					l_token_text_array.extend (compiled_source.last_integer_64)
					i := i + 1
				end
				compiled_source.close
			end
		end

	same_software_version (compiled_source_path: EL_FILE_PATH): BOOLEAN
		do
			if attached open_raw (compiled_source_path, Read) as compiled_source then
				compiled_source.read_natural_32
				Result := Build_info.version_number = compiled_source.last_natural_32
				compiled_source.close
			end
		end

	write_tokens_text (compiled_source_path: like source_file_path)
		local
			area: like tokens_text.area; array_area: like token_text_array.area
			i, count: INTEGER
		do
			if attached open_raw (compiled_source_path, Write) as compiled_source then
				area := tokens_text.area
				count := tokens_text.count
				compiled_source.put_natural_32 (Build_info.version_number)
				compiled_source.put_integer (count)
				from i := 0 until i = count loop
					compiled_source.put_natural (area.item (i).natural_32_code)
					i := i + 1
				end

				array_area := token_text_array.area
				count := token_text_array.count
				compiled_source.put_integer (count)
				from i := 0 until i = count loop
					compiled_source.put_integer_64 (array_area [i])
					i := i + 1
				end
				compiled_source.close
			end
		end

feature {NONE} -- Internal attributes

	tokens_text: STRING_32

end
