note
	description: "Summary description for {TEXT_PARSER_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-11 12:32:36 GMT (Monday 11th January 2016)"
	revision: "7"

class
	TEXT_PARSER_TEST_SET

inherit
	EQA_TEST_SET

	EL_PYXIS_ZTEXT_PATTERN_FACTORY
		export
			{NONE} all
		undefine
			default_create
		end

	PYXIS_ATTRIBUTE_PARSER_TEST_DATA
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Tests

	test_back_reference_match
		note
			testing: "covers/{EL_BACK_REFERENCE_MATCH_TP}.match_count"
		local
			xml, name, output: ZSTRING; pattern: like all_of
		do
			create output.make_empty
			pattern := xml_text_element (
				agent (matched: EL_STRING_VIEW; a_output: ZSTRING)
					do
						a_output.append (matched.to_string)
					end (?, output)
			)
			pattern.parse (XML_name_template #$ [Name_susan])
			assert ("match_count OK", Name_susan ~ output)
		end

	test_find_all
		note
			testing: "covers/{EL_TEXT_PATTERN}.find_all"
		local
			pattern: EL_TEXT_PATTERN; comma_separated_list: EL_ZSTRING
		do
			create comma_separated_list.make_empty
			pattern := pyxis_assignment (comma_separated_list)
			pattern.find_all (Attributes_source_line, agent on_unmatched_text (?, comma_separated_list))
			assert ("find_all OK", Attributes_comma_separated_values ~ comma_separated_list)
		end

	test_match_p1_while_not_p2
		note
			testing: "covers/{EL_MATCH_P1_WHILE_NOT_P2_MATCH_TP}.match_count"
		local
			list: ARRAYED_LIST [STRING]; boolean: BOOLEAN; start_index, end_index: INTEGER_32
			assignment: like eiffel_string_assignment; view: EL_STRING_8_VIEW
		do
			create list.make (1)
			assignment := eiffel_string_assignment (list)
			view := Eiffel_statement
			assignment.match (view)
			if assignment.is_matched and then assignment.count = Eiffel_statement.count then
				assignment.call_actions (view)
				start_index := Eiffel_statement.index_of ('"', 1) + 1
				end_index := Eiffel_statement.count - 1
				boolean := list.first ~ Eiffel_statement.substring (start_index, end_index)
			end
			assert ("match_p1_while_not_p2 OK", boolean)
		end

	test_integer_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count"
		local
			number: DOUBLE; boolean: BOOLEAN
		do
			across Numbers as n loop
				number := n.item
				if number.rounded /~ number then
					boolean := not integer_constant.matches_string_general (number.out)
				else
					boolean := integer_constant.matches_string_general (number.out)
				end
				assert ("matches_string_general OK", boolean)
			end
		end

	test_numeric_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count"
		local
			number: DOUBLE
		do
			across Numbers as n loop
				number := n.item
				assert ("matches_string_general OK", numeric_constant.matches_string_general (number.out))
			end
		end

	test_numbers_array_parsing
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/{EL_LITERAL_TEXT_PATTERN}.match_count",
						"covers/{EL_MATCH_ZERO_OR_MORE_TIMES_TP}.match_count",
						"covers/{EL_MATCH_ANY_CHAR_IN_SET_TP}.match_count",
						"covers/{EL_LITERAL_CHAR_TP}.match_count",
						"covers/{EL_MATCH_CHAR_IN_ASCII_RANGE_TP}.match_count"
		local
			pattern: like numeric_array_pattern; view: EL_STRING_8_VIEW
			is_full_match: BOOLEAN; number_list: ARRAYED_LIST [DOUBLE]
		do
			create number_list.make (10)
			pattern := numeric_array_pattern (number_list)
			create view.make (numbers_string)
			pattern.match (view)
			is_full_match := pattern.is_matched and pattern.count = view.count
			assert ("numeric_array_pattern: is_full_match OK", is_full_match)
			pattern.call_actions (view)
			assert ("parsed Eiffel numeric array OK", number_list.to_array ~ numbers)
		end

	test_pyxis_parser
		note
			testing: "covers/{EL_PYXIS_ATTRIBUTE_PARSER_2}.parse"
		local
			parser: EL_PYXIS_ATTRIBUTE_PARSER
			table: like Attribute_table; name, value: EL_ZSTRING
		do
			create parser.make
			parser.set_source_text (Attributes_source_line)
			parser.parse
			parser.parse -- Ensure repeatability
			create table.make_equal (5)
			across parser.attribute_list as l_attribute loop
				name := l_attribute.item.name; value := l_attribute.item.value
				if value.is_integer then
					table [name] := value.to_integer
				elseif value.is_double then
					table [name] := value.to_double
				elseif value.is_boolean then
					table [name] := value.to_boolean
				else
					table [name] := value.to_string_8
				end
			end
			assert ("pyxis_parser OK", table ~ Attribute_table)
		end

	test_quoted_string
		local
			pattern: like quoted_string
			str_1, str_2: ZSTRING
		do
			str_1 := "one two"; create str_2.make_empty
			pattern := quoted_string (string_literal ("\%""), agent on_unmatched_text (?, str_2))
			pattern.parse (str_1.enclosed ('"', '"'))
			assert ("match OK", str_1 ~ str_2)
		end

	test_recursive_match
		note
			testing: "covers/{EL_RECURSIVE_TEXT_PATTERN}.match"
		local
			eiffel_type: like type
			type_string: ZSTRING
		do
			eiffel_type := type
			across Eiffel_types.split ('%N') as line loop
				type_string := line.item
				assert ("match OK", type_string.matches (eiffel_type))
				type_string := type_string + " X"
				assert ("not match OK", not type_string.matches (eiffel_type))
			end
		end

	test_xpath_parser
		note
			testing: "covers/{EL_MATCH_P1_WHILE_NOT_P2_MATCH_TP}.match"
		local
			parser: EL_XPATH_PARSER; steps: LIST [STRING]; parsed_step: EL_PARSED_XPATH_STEP
			index_of_at, index_of_equal: INTEGER
		do
			create parser.make
			across Xpaths.split ('%N') as xpath loop
				steps := xpath.item.split ('/')
				parser.set_source_text (xpath.item)
				parser.parse
				across steps as step loop
					parsed_step := parser.step_list.i_th (step.cursor_index)
					assert ("parser OK", parsed_step.step ~ step.item)
					index_of_at := step.item.index_of ('@', 1)
					if index_of_at > 0 then
						index_of_equal := step.item.index_of ('=', 1)
						assert ("parser OK",
							parsed_step.selecting_attribute_name ~ step.item.substring (index_of_at, index_of_equal - 1)
						)
					end
				end
			end
		end

feature {NONE} -- Patterns

	numeric_array_pattern (list: ARRAYED_LIST [DOUBLE]): like all_of
		do
			Result := all_of (<<
				string_literal ("<<"), maybe_white_space,
				numeric_constant |to| agent on_numeric (? ,list),
				zero_or_more (
					all_of (<<
						maybe_white_space, character_literal (','), maybe_white_space,
						numeric_constant |to| agent on_numeric (? ,list)
					>>)
				),
				maybe_white_space,
				string_literal (">>")
			>>)
		end

	pyxis_assignment (comma_separated_list: EL_ZSTRING): like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('='),
				maybe_non_breaking_white_space,
				one_of (<<
					xml_identifier |to| agent on_value (?, comma_separated_list),
					numeric_constant |to| agent on_value (?, comma_separated_list),
					quoted_string (double_quote_escape_sequence, agent on_quoted_value (?, True, comma_separated_list)),
					single_quoted_string (single_quote_escape_sequence, agent on_quoted_value (?, False, comma_separated_list))
				>>)
			>> )
		end

	xml_text_element (a_action: like default_action): like all_of
		local
			tag_name: like c_identifier
			any_text: like while_not_p1_repeat_p2
		do
			any_text := while_not_p1_repeat_p2 (character_literal ('<'), any_character )
			any_text.set_action_combined_p2 (a_action)
			tag_name := c_identifier
			Result := all_of (<<
				character_literal ('<'),
				tag_name,
				character_literal ('>'),
				any_text,
				character_literal ('/'),
				previously_matched (tag_name),
				character_literal ('>')
			>>)
		end

feature {NONE} -- Parse events handlers

	on_numeric (matched: EL_STRING_VIEW; list: ARRAYED_LIST [DOUBLE])
		local
			str: STRING
		do
			str := matched.to_string_8
			if str.is_double then
				list.extend (str.to_double)
			end
		end

	on_value (matched: EL_STRING_VIEW; comma_separated_list: EL_ZSTRING)
		do
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (matched.to_string)
		end

	on_unmatched_text (matched: EL_STRING_VIEW; source: EL_ZSTRING)
		do
			source.append_string (matched.to_string)
		end

	on_quoted_value (matched: EL_STRING_VIEW; is_double_quote: BOOLEAN; comma_separated_list: EL_ZSTRING)
		local
			quote_count: INTEGER
		do
			if is_double_quote then
				quote_count := 2
			else
				quote_count := 1
			end
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (matched.to_string.quoted (quote_count))
		end

	on_str (matched: EL_STRING_VIEW; list: ARRAYED_LIST [STRING])
		do
			list.extend (matched.to_string_8)
		end

feature {NONE} -- Implementation

	numbers_string: STRING
		do
			create Result.make (Numbers.count * 4)
			Result.append ("<< ")
			across Numbers as n loop
				if n.cursor_index > 1 then
					Result.append (", ")
				end
				Result.append (number_to_string (n.item).out)
			end
			Result.append (" >>")
		end

	Eiffel_string_assignment (list: ARRAYED_LIST [STRING]): like all_of
		do
			Result := all_of (<<
				identifier, maybe_non_breaking_white_space, string_literal (":="), maybe_non_breaking_white_space,
				quoted_manifest_string (agent on_str (?, list))
			>>)
		end

feature {NONE} -- Constants

	XML_name_template: ZSTRING
		once
			Result := "<name>%S</name>"
		end

	Name_susan: ZSTRING
		once
			Result := "Susan Miller"
		end

	Numbers: ARRAY [DOUBLE]
		once
			Result := << 1.23, 1, 10, 12.3, 12.3, 123, -1, -10, -1.23, -12.3, -123 >>
		end

	Eiffel_statement: STRING = "[
		str := "1%N2%"/3"
	]"

	Eiffel_types: ZSTRING
		once
			Result := "[
				STRING
				ARRAY [STRING]
				HASH_TABLE [STRING, STRING]
				ARRAY [HASH_TABLE [STRING, STRING]]
				HASH_TABLE [ARRAY [HASH_TABLE [STRING, STRING]], STRING]
			]"
		end


	Xpaths: STRING = "[
		head/meta[@name='title']/@content
		body/seq
		@id
		audio
	]"
end