note
	description: "Text parser test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 11:15:39 GMT (Friday 14th February 2020)"
	revision: "8"

class
	TEXT_PARSER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		undefine
			default_create
		end

	PYXIS_ATTRIBUTE_PARSER_TEST_DATA
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
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

	test_match_p1_while_not_p2
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

	on_unmatched_text (matched: EL_STRING_VIEW; source: EL_ZSTRING)
		do
			source.append_string (matched.to_string)
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

end
