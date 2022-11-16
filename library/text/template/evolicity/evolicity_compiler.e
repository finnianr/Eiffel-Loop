note
	description: "Evolicity compiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "19"

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
			quoted_string as quoted_string_pattern,
			token as as_literal
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

	modification_time: EL_DATE_TIME

feature -- Element change

 	set_source_text_from_file (file_path: FILE_PATH)
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

feature {NONE} -- Loop Directives

	across_directive: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_across)	|to| agent on_loop (Token.keyword_across, ?),
				variable_reference 						|to| agent on_loop (Token.keyword_in, ?),
				as_literal (Token.keyword_as),
				variable_reference						|to| agent on_loop (Token.keyword_as, ?),
				as_literal (Token.keyword_loop),
				recurse (agent zero_or_more_directives, True),
				as_literal (Token.keyword_end)		|to| agent on_loop (Token.keyword_end, ?)
			>> )
		end

	foreach_directive: like all_of
			-- Match: foreach ( V in V )
		do
			Result := all_of (<<
				as_literal (Token.keyword_foreach)	|to| agent on_loop (Token.keyword_foreach, ?),
				variable_reference						|to| agent on_loop (Token.keyword_as, ?),
				optional (
					variable_reference					|to| agent on_loop (Token.keyword_as, ?)
				),
				as_literal (Token.keyword_in),
				variable_reference 						|to| agent on_loop (Token.keyword_in, ?),
				as_literal (Token.keyword_loop),
				recurse (agent zero_or_more_directives, True),
				as_literal (Token.keyword_end)		|to| agent on_loop (Token.keyword_end, ?)
			>> )
		end

feature {NONE} -- Branch Directives

	else_directive: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_else),
				recurse (agent zero_or_more_directives, True)
			>> )
		end

	if_else_end_directive: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_if) 		|to| agent on_if (Token.keyword_if, ?),
				boolean_expression,
				as_literal (Token.keyword_then) 		|to| agent on_if (Token.keyword_then, ?),
				recurse (agent zero_or_more_directives, True),
				optional (else_directive)				|to| agent on_if (Token.keyword_else, ?),
				as_literal (Token.keyword_end) 		|to| agent on_if (Token.keyword_end, ?)
			>> )
		end

feature {NONE} -- Directives

	control_directive: like one_of
			--
		do
			Result := one_of (<< foreach_directive, across_directive, if_else_end_directive >> )
		end

	directive: like one_of
			--
		do
			Result := one_of (
				<< as_literal (Token.Free_text)				|to| agent on_free_text,
					as_literal (Token.Double_dollor_sign)	|to| agent on_dollor_sign_escape,
					variable_reference 							|to| agent on_variable_reference,
					evaluate_directive,
					include_directive,
					control_directive
				>>
			)
		end

	evaluate_directive: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_evaluate)					|to| agent on_evaluate (Token.keyword_evaluate, ?),
				as_literal (Token.White_text)							|to| agent on_evaluate (Token.White_text, ?),
				one_of (<<
					as_literal (Token.Template_name_identifier)	|to| agent on_evaluate (Token.Template_name_identifier, ?),
					as_literal (Token.Quoted_string)					|to| agent on_evaluate (Token.Quoted_string, ?),
					variable_reference 									|to| agent on_evaluate (Token.operator_dot, ?)
				>>),
				variable_reference 										|to| agent on_evaluate (0, ?)
			>> )
		end

	include_directive: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_include)	|to| agent on_include (Token.keyword_include, ?),
				as_literal (Token.White_text)			|to| agent on_include (Token.White_text, ?),
				one_of (<<
					as_literal (Token.Quoted_string)	|to| agent on_include (Token.Quoted_string, ?),
					variable_reference 					|to| agent on_include (Token.operator_dot, ?)
				>>)
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
				one_of (<< as_literal (Token.keyword_and), as_literal (Token.keyword_or) >>),
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

	comparable_numeric: like one_of
		do
			Result := one_of (<<
				variable_reference 							|to| agent on_comparable (Token.operator_dot, ?),
				as_literal (Token.integer_64_constant)	|to| agent on_comparable (Token.integer_64_constant, ?),
				as_literal (Token.double_constant)		|to| agent on_comparable (Token.double_constant, ?)
			>>)
		end

	constant_pattern: like one_of
			--
		do
			Result := one_of (<<
				as_literal (Token.Quoted_string),
				as_literal (Token.double_constant),
				as_literal (Token.integer_64_constant)
			>>)
		end

	function_call: like all_of
		do
			Result := all_of (<<
				as_literal (Token.Left_bracket),
				constant_pattern,
				while_not_p1_repeat_p2 (
					as_literal (Token.Right_bracket),
					all_of (<<
						as_literal (Token.Comma_sign),
						constant_pattern
					>>)
				)
			>>)
		end

	negated_boolean_value: like all_of
			--
		do
			Result := all_of (<<
				as_literal (Token.keyword_not), boolean_value
			>>)
			Result.set_action_last (agent on_boolean_not_expression)
		end

	numeric_comparison_expression: like all_of
			--
		do
			Result := all_of ( <<
				comparable_numeric, numeric_comparison_operator, comparable_numeric
			>>)
			Result.set_action_last (agent on_comparison_expression)
		end

	numeric_comparison_operator: like all_of
			--
		do
			Result := one_of ( <<
				as_literal (Token.operator_less_than)		|to| agent on_numeric_comparison ('<', ?),
				as_literal (Token.operator_greater_than)	|to| agent on_numeric_comparison ('>', ?),
				as_literal (Token.operator_equal_to) 		|to| agent on_numeric_comparison ('=', ?),
				as_literal (Token.operator_not_equal_to)
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
				as_literal (Token.Unqualified_name),
				zero_or_more (
					all_of (<< as_literal (Token.operator_dot), as_literal (Token.Unqualified_name) >> )
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

	same_software_version (compiled_source_path: FILE_PATH): BOOLEAN
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