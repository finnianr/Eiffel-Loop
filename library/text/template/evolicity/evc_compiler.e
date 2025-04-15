note
	description: "Evolicity compiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:20:20 GMT (Tuesday 15th April 2025)"
	revision: "31"

class
	EVC_COMPILER

inherit
	EL_TOKEN_PARSER [EVC_FILE_LEXER]
		rename
			match_full as parse,
			parse as parse_and_compile,
			fully_matched as parse_succeeded,
			call_actions as compile
		export
			{ANY} parse, parse_succeeded
		redefine
			set_source_text_from_file, set_source_text_from_line_source
		end

	EVC_PARSE_ACTIONS
		rename
			make as reset_directives
		end

	TP_FACTORY
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
			reset_directives
			encoding := 0 -- indicates a text source by default
		end

feature -- Access

	compiled_template: EVC_COMPILED_TEMPLATE
		do
			reset_directives
			compile
			create Result.make (compound_directive.to_array, modification_time, Current)
			Result.set_minimum_buffer_length ((source_text.count * 1.5).floor)
		end

	modification_time: INTEGER

feature -- Element change

	set_source_text_from_file (file_path: FILE_PATH)
		require else
			valid_encoding_set: valid_encoding (encoding_type | encoding_id)
		do
			modification_time := file_path.modification_time
			Precursor (file_path)
		end

	set_source_text_from_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
			--
		local
			compiled_source_path: FILE_PATH
		do
			source_file_path := lines.file_path
			set_encoding_from_other (lines) -- May have detected UTF-8 BOM

			compiled_source_path := source_file_path.with_new_extension ("evc")
			if compiled_source_path.exists
				and then same_software_version (compiled_source_path)
				and then compiled_source_path.modification_time > source_file_path.modification_time
			then
				read_tokens_text (compiled_source_path)
				source_text := lines.joined
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
				keyword (Token.keyword_across)	|to| loop_action (Token.keyword_across),
				variable_reference 					|to| loop_action (Token.keyword_in),
				keyword (Token.keyword_as),
				value_reference						|to| loop_action (Token.keyword_as),
				keyword (Token.keyword_loop),
				recurse (agent zero_or_more_directives, 1),
				keyword (Token.keyword_end)		|to| loop_action (Token.keyword_end)
			>>)
		end

	foreach_directive: like all_of
			-- Match: foreach ( V in V )
		do
			Result := all_of (<<
				keyword (Token.keyword_foreach)	|to| loop_action (Token.keyword_foreach),
				variable_reference					|to| loop_action (Token.keyword_as),
				optional (
					variable_reference				|to| loop_action (Token.keyword_as)
				),
				keyword (Token.keyword_in),
				value_reference 						|to| loop_action (Token.keyword_in),
				keyword (Token.keyword_loop),
				recurse (agent zero_or_more_directives, 1),
				keyword (Token.keyword_end)		|to| loop_action (Token.keyword_end)
			>>)
		end

feature {NONE} -- Branch Directives

	else_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_else),
				recurse (agent zero_or_more_directives, 1)
			>>)
		end

	if_else_end_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_if) 		|to| if_action (Token.keyword_if),
				boolean_expression,
				keyword (Token.keyword_then) 		|to| if_action (Token.keyword_then),
				recurse (agent zero_or_more_directives, 1),
				optional (else_directive)			|to| if_action (Token.keyword_else),
				keyword (Token.keyword_end) 		|to| if_action (Token.keyword_end)
			>>)
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
				<< keyword (Token.Free_text)				|to| agent on_free_text,
					keyword (Token.Double_dollor_sign)	|to| agent on_dollor_sign_escape,
					value_reference 							|to| agent on_value_reference,
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
				keyword (Token.keyword_evaluate)					|to| evaluate_action (Token.keyword_evaluate),
				keyword (Token.White_text)							|to| evaluate_action (Token.White_text),
				one_of (<<
					keyword (Token.Template_name_identifier)	|to| evaluate_action (Token.Template_name_identifier),
					keyword (Token.Literal_string)					|to| evaluate_action (Token.Literal_string),
					variable_reference 								|to| evaluate_action (Token.operator_dot)
				>>),
				variable_reference 									|to| evaluate_action (0)
			>> )
		end

	include_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_include)	|to| include_action (Token.keyword_include),
				keyword (Token.White_text)			|to| include_action (Token.White_text),
				one_of (<<
					keyword (Token.Literal_string)	|to| include_action (Token.Literal_string),
					variable_reference 				|to| include_action (Token.operator_dot)
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
				one_of (<< keyword (Token.keyword_and), keyword (Token.keyword_or) >>),
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
				comparison_expression,
				value_reference |to| agent on_boolean_variable
			>>)
		end

	comparable_item: like one_of
		do
			Result := one_of (<<
				value_reference 						|to| comparable_action (Token.operator_dot),
				keyword (Token.Literal_integer)	|to| comparable_action (Token.Literal_integer),
				keyword (Token.literal_real)		|to| comparable_action (Token.literal_real),
				keyword (Token.Literal_string)	|to| comparable_action (Token.Literal_string)
			>>)
		end

	comparison_expression: like all_of
			--
		do
			Result := all_of ( <<
				comparable_item, comparison_operator, comparable_item
			>>)
			Result.set_action_last (agent on_comparison_expression)
		end

	comparison_operator: like all_of
			--
		do
			Result := one_of ( <<
				keyword (Token.operator_less_than)		|to| comparison_action ('<'),
				keyword (Token.operator_greater_than)	|to| comparison_action ('>'),
				keyword (Token.operator_equal_to) 		|to| comparison_action ('='),
				keyword (Token.operator_not_equal_to)	|to| comparison_action ('/')
			>>)
		end

	function_argument: like one_of
		do
			Result := one_of (<<
				variable_reference,
				keyword (Token.Literal_string),
				keyword (Token.literal_real),
				keyword (Token.Literal_integer)
			>>)
		end

	function_call: like all_of
		do
			Result := all_of (<<
				keyword (Token.at_sign),
				variable_reference,
				keyword (Token.Left_bracket),
				function_argument,
				while_not_p1_repeat_p2 (
					keyword (Token.Right_bracket),
					all_of (<<
						keyword (Token.Comma_sign),
						function_argument
					>>)
				)
			>>)
		end

	negated_boolean_value: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_not), boolean_value
			>>)
			Result.set_action_last (agent on_boolean_not_expression)
		end

	simple_boolean_expression: like one_of
			--
		do
			Result := one_of (<<
				negated_boolean_value, boolean_value
			>>)
		end

	value_reference: like all_of
		do
			Result := one_of (<< function_call, variable_reference >>)
		end

	variable_reference: like all_of
		do
			Result := all_of (<<
				keyword (Token.Unqualified_name),
				zero_or_more (
					all_of (<< keyword (Token.operator_dot), keyword (Token.Unqualified_name) >> )
				)
			>>)
		end

feature {NONE} -- Implementation

	read_tokens_text (compiled_source_path: FILE_PATH)
		local
			i, count, lower, upper: INTEGER
		do
			if attached open_raw (compiled_source_path, Read) as compiled_source then
				-- skip software version
				compiled_source.move ({PLATFORM}.Natural_32_bytes)

				compiled_source.read_integer
				count := compiled_source.last_integer
				create tokens_text.make (count)
				if attached tokens_text as tokens then
					from i := 1 until i > count loop
						compiled_source.read_natural
						tokens.append_code (compiled_source.last_natural)
						i := i + 1
					end
				end

				compiled_source.read_integer
				count := compiled_source.last_integer
				source_interval_list.grow (count)
				if attached source_interval_list as list then
					from i := 1 until i > count loop
						compiled_source.read_integer; lower := compiled_source.last_integer
						compiled_source.read_integer; upper := compiled_source.last_integer
						list.extend (lower, upper)
						i := i + 1
					end
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

	write_tokens_text (compiled_source_path: FILE_PATH)
		local
			i, i_final, count: INTEGER
		do
			if attached open_raw (compiled_source_path, Write) as compiled_source
				and then attached tokens_text.area as area
			then
				count := tokens_text.count
				compiled_source.put_natural_32 (Build_info.version_number)
				compiled_source.put_integer (count)
				from i := 0 until i = count loop
					compiled_source.put_natural (area.item (i).natural_32_code)
					i := i + 1
				end
				if attached source_interval_list.area as array_area then
					count := source_interval_list.count
					compiled_source.put_integer (count)
					i_final := count * 2
					from i := 0 until i = i_final loop
						compiled_source.put_integer_32 (array_area [i])
						i := i + 1
					end
				end
				compiled_source.close
			end
		end

end