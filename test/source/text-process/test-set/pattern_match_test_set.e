note
	description: "[
		Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]
		using ${STRING_8} source text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 11:29:22 GMT (Tuesday 15th April 2025)"
	revision: "38"

class
	PATTERN_MATCH_TEST_SET

inherit
	EL_EQA_TEST_SET
		redefine
			on_prepare
		end

	TP_EIFFEL_FACTORY
		undefine
			default_create
		end

	EL_MODULE_HTML

	TP_SHARED_OPTIMIZED_FACTORY

	EL_SHARED_TEST_TEXT; EL_SHARED_TEST_NUMBERS; EL_SHARED_TEST_XDOC_DATA

	EL_TEST_TEXT_CONSTANTS; EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["alpha_character_match",			  agent test_alpha_character_match],
				["back_reference_match",			  agent test_back_reference_match],
				["end_of_line",						  agent test_end_of_line],
				["find_all",							  agent test_find_all],
				["integer_match",						  agent test_integer_match],
				["literal_find_all",					  agent test_literal_find_all],
				["numbers_array_parsing",			  agent test_numbers_array_parsing],
				["numeric_match",						  agent test_numeric_match],
				["pyxis_attribute_parser",			  agent test_pyxis_attribute_parser],
				["quoted_character_array_parsing", agent test_quoted_character_array_parsing],
				["quoted_string",						  agent test_quoted_string],
				["recursive_match",					  agent test_recursive_match],
				["string_substitution",				  agent test_string_substitution],
				["html_substitution",				  agent test_html_substitution],
				["text_matcher",						  agent test_text_matcher],
				["xpath_parser",						  agent test_xpath_parser]
			>>)
		end

feature -- Test

	test_alpha_character_match
		note
			testing: "covers/{TP_ZSTRING_ALPHA_CHAR}.match_count"
		local
			str: ZSTRING
		do
			str := "1a"
			core := optimal_core (str)
			if attached letter as p then
				p.match (0, str)
				assert ("no match", not p.is_matched)
				p.match (1, str)
				assert ("matched", p.is_matched)
			end
		end

	test_back_reference_match
		note
			testing: "[
				covers/{TP_BACK_REFERENCE_MATCH}.match_count,
				covers/{TP_REFERENCE_MATCH}.match_count,
				covers/{TP_P2_WHILE_NOT_P1_MATCH}.match_count,
				covers/{TP_ANY_WHILE_NOT_P_MATCH}.match_count
			]"
		local
			output: ZSTRING; pattern: like all_of
			xml_text_element: like xml_text_element_list.item
		do
			create output.make_empty
			across xml_text_element_list as list loop
				xml_text_element := list.item
				across << Empty_string_8, Name_susan >> as name loop
					set_source_text (Xml_element #$ [name.item])
					output.wipe_out
					pattern := xml_text_element (agent output.append_substring_general (source_text, ?, ?))
					pattern.parse (source_text)
					if pattern.is_matched then
						assert ("match_count OK", name.item ~ output)
					else
						failed ("parse OK")
					end
				end
			end
		end

	test_end_of_line
		note
			testing: "covers/{TP_END_OF_LINE_CHAR}.match",
				"covers/{TP_STRING_8_END_OF_LINE_CHAR}.match",
				"covers/{TP_ZSTRING_END_OF_LINE_CHAR}.match"
		local
			pattern: like zero_or_more; output: ZSTRING
			line_pattern: like while_not_p_match_any
			line_list: ARRAYED_LIST [STRING_GENERAL]
		do
			create output.make_empty; create line_list.make (10)
			line_pattern := while_not_p_match_any (end_of_line_character)
			line_pattern.set_leading_text_action (agent on_line (?, ?, line_list))
			pattern := zero_or_more (line_pattern)
			set_source_text (Eiffel_type_declarations)
			pattern.parse (source_text)
			if pattern.is_matched then
				across Eiffel_type_declarations.split ('%N') as line loop
					if line_list.valid_index (line.cursor_index) then
						assert_same_string ("text reconstructed", line_list [line.cursor_index], line.item)
					else
						failed ("same item count")
					end
				end
			else
				failed ("matched")
			end
		end

	test_find_all
		note
			testing: "covers/{TP_RECURSIVE}.match"
		local
			pattern: like class_name; output: ZSTRING
			padding: STRING
		do
			create padding.make_filled (' ', 2)
			create output.make_empty
			pattern := class_name |to| agent append_to (?, ?, output)
			across Eiffel_type_declarations.split ('%N') as line loop
				set_source_text (line.item)
				source_text.prepend (padding); source_text.append (padding)
				output.wipe_out
				pattern.find_all (source_text, agent append_to (?, ?, output))
				assert_same_string ("text reconstructed", output, source_text)
			end
		end

	test_html_substitution
		-- PATTERN_MATCH_TEST_SET.test_html_substitution
		note
			testing: "[
				covers/{EL_SUBST_VARIABLE_PARSER}.parse,
				covers/{EL_SUBST_VARIABLE_PARSER}.set_variables_from_object,
				covers/{EL_SUBST_VARIABLE_PARSER}.set_variables_from_array,
				covers/{EL_MARKUP_ROUTINES}.book_mark_anchor_markup
			]"
		do
			assert_same_string ("same HTML", HTML.book_mark_anchor_markup ("1", "one"), "<a id=%"1%">one</a>")
		end

	test_integer_match
		note
			testing: "covers/{TP_ALL_IN_LIST}.match_count",
						"covers/EL_MATCH_ONE_OR_MORE_TIMES}.match_count",
						"covers/EL_MATCH_COUNT_WITHIN_BOUNDS}.match_count",
						"covers/EL_STRING_8_NUMERIC_CHAR}.match_count",
						"covers/EL_STRING_8_LITERAL_CHAR}.match_count"
		local
			double: DOUBLE; boolean: BOOLEAN
		do
			core := optimal_core (Empty_string_8)
			across Number.Doubles_list as n loop
				double := n.item
				if double.rounded /~ double then
					boolean := not signed_integer.matches_string_general (double.out)
				else
					boolean := signed_integer.matches_string_general (double.out)
				end
				assert ("matches_string_general OK", boolean)
			end
		end

	test_literal_find_all
		-- test `find_all' with leading `string_literal' in pattern
		note
			testing: "covers/{TP_RECURSIVE}.match"
		local
			pattern: like all_of; output, name: ZSTRING
		do
			name := "STRING"
			create output.make_empty
			pattern := hash_table_pattern (agent append_to (?, ?, output))
			set_source_text (Eiffel_type_declarations)
			pattern.find_all (source_text, Void)
			assert ("same text", output ~ name.multiplied (6))
		end

	test_numbers_array_parsing
		note
			testing: "covers/{TP_ALL_IN_LIST}.match_count",
						"covers/{TP_LITERAL_TEXT_PATTERN}.match_count",
						"covers/{TP_ZERO_OR_MORE_TIMES}.match_count",
						"covers/{TP_ANY_CHAR_IN_SET}.match_count",
						"covers/{TP_LITERAL_CHAR}.match_count",
						"covers/{TP_LOOP}.internal_call_actions",
						"covers/{TP_LOOP}.match",
						"covers/{TP_P1_UNTIL_P2_MATCH}.match_count",
						"covers/{TP_P2_WHILE_NOT_P1_MATCH}.match_count"

		local
			manifest_text: STRING
		do
			across numeric_array_pattern_list as array_pattern loop
				lio.put_labeled_string ("function", "numeric_array_pattern_" + array_pattern.cursor_index.out)
				lio.put_new_line
				across 0 |..| 3 as upper_limit loop
					if array_pattern.is_last implies upper_limit.item >= 2 then
						test_array_pattern (array_pattern.item, upper_limit.item)
					end
				end
				lio.put_new_line
			end
		end

	test_numeric_match
		note
			testing: "covers/{TP_ALL_IN_LIST}.match_count",
						"covers/{TP_ONE_OR_MORE_TIMES}.match_count",
						"covers/{TP_COUNT_WITHIN_BOUNDS}.match_count",
						"covers/{TP_STRING_8_NUMERIC_CHAR}.match_count",
						"covers/{TP_STRING_8_LITERAL_CHAR}.match_count"
		do
			across Number.Doubles_list as double loop
				set_source_text (double.item.out)
				assert ("matches_string_general OK", decimal_constant.matches_string_general (source_text))
			end
		end

	test_pyxis_attribute_parser
		-- PATTERN_MATCH_TEST_SET.test_pyxis_attribute_parser
		local
			parser: PYXIS_ATTRIBUTE_TEST_PARSER; index: INTEGER
			leading_tabs, trailing_spaces, source_line_1, source_line_2: STRING
		do
			create leading_tabs.make_filled ('%T', 2)
			create trailing_spaces.make_filled (' ', 2)

			source_line_1 := Xdoc.pyxis_attributes_line (Xdoc.Attribute_table)
			source_line_2 := leading_tabs + source_line_1 + trailing_spaces

			create parser.make

			across << source_line_1, source_line_2 >> as line loop
				if line.item.starts_with (leading_tabs) then
					parser.set_substring_source_text (line.item, 3, line.item.count - 2)
				else
					parser.set_source_text (line.item)
				end
				assert ("table is empty", parser.table.is_empty)
				parser.parse
				across Xdoc.Attribute_table as table loop
					if parser.table.has_key (table.key) then
						if attached {DOUBLE} table.item as double then
							assert ("same value", Number.double_to_string (double) ~ parser.table.found_item)
						else
							assert ("same value", table.item.out ~ parser.table.found_item)
						end
					else
						failed ("has key " + table.key)
					end
				end
			end
		end

	test_quoted_character_array_parsing
		note
			testing: "covers/{TP_EIFFEL_QUOTED_CHAR}.match",
				"covers/{TP_ZSTRING_EIFFEL_QUOTED_CHAR}.match",
				"covers/{TP_STRING_8_EIFFEL_QUOTED_CHAR}.match"
		local
			pattern: like character_array_pattern; output, content: ZSTRING
		do
			create output.make_empty
			set_source_text (Eiffel_character_array)
			pattern := character_array_pattern (agent on_quoted_character (?, output))
			pattern.parse (source_text)
			if pattern.is_matched then
				assert_same_string (Void, output, "AA%N'")
			else
				failed ("matched")
			end
		end

	test_quoted_string
		note
			testing: "covers/{TP_QUOTED_STRING}.match"
		local
			pattern: TP_QUOTED_STRING
			output, content: ZSTRING
		do
			create output.make_empty
			across <<
				core.new_c_quoted_string ('"', agent on_quoted (?, output)),
				core.new_eiffel_quoted_string ('"', agent on_quoted (?, output))

			>> as list loop
				pattern := list.item
				output.wipe_out
				create content.make_empty
				if pattern.language_name ~ "C" then
					set_source_text ("[
						"-\n-\"-\\"
					]")
				else
					set_source_text ("[
						"-%N-%"-%%-%/65/"
					]")
				end
				output.wipe_out
				pattern.set_action (agent on_quoted_substring (?, ?, content))
				pattern.parse (source_text)
				if pattern.is_matched then
					assert_same_string ("string without quotes", content.enclosed ('"', '"'), source_text)
					if pattern.language_name ~ "C" then
						assert_same_string (Void, output, "-%N-%"-\")
					else
						assert_same_string (Void, output, "-%N-%"-%%-A")
					end
				else
					failed ("matched")
				end
			end
		end

	test_recursive_match
		note
			testing: "covers/{TP_RECURSIVE_TEXT_PATTERN}.match"
		local
			eiffel_type: like class_type; type_string: ZSTRING
		do
			create type_string.make_empty
			core := optimal_core (type_string)

			eiffel_type := class_type
			across Eiffel_type_declarations.split ('%N') as line loop
				type_string := line.item
				assert ("match OK", type_string.matches (eiffel_type))
				type_string := type_string + " X"
				assert ("not match OK", not type_string.matches (eiffel_type))
			end
		end

	test_string_substitution
		-- PATTERN_MATCH_TEST_SET.test_string_substitution
		note
			testing: "[
				covers/{EL_SUBST_VARIABLE_PARSER}.parse,
				covers/{EL_TEMPLATE_LIST}.put_fields,
				covers/{EL_TEMPLATE_LIST}.put_array
			]"
		local
			template_list: ARRAY [EL_SUBSTITUTION_TEMPLATE [STRING_GENERAL]]; target_text: STRING
		do
			across << True, False >> as use_reflection loop
				across << Text.country_template, Text.Country_template_canonical >> as l_type loop
					target_text := Text.country_substituted (Ireland.name, Ireland.code, Ireland.population)
					template_list := <<
						create {EL_STRING_8_TEMPLATE}.make (l_type.item),
						create {EL_STRING_32_TEMPLATE}.make (l_type.item),
						create {EL_ZSTRING_TEMPLATE}.make (l_type.item)
					>>
					across template_list as template loop
						if use_reflection.item then
							template.item.put_fields (ireland)
						else
							template.item.put_array (<<
								[Text.Country.name, Ireland.name],
								[Text.Country.code, Ireland.code],
								[Text.Country.population, Ireland.population]
							>>)
						end
						assert_same_string (Void, template.item.substituted, target_text)
					end
				end
			end
		end

	test_text_matcher
		note
			testing: "covers/{TP_ONE_OR_MORE_TIMES}.match_count",
						"covers/{TP_ANY_CHAR_IN_SET}.match_count",
						"covers/{EL_PARSER}.find_all"
		local
			character_set, line: ZSTRING; output, output_2: ZSTRING
			matcher: EL_TEXT_MATCHER
		do
			create output.make_empty
			create output_2.make_empty
			create matcher.make (agent start_of_line)

			across Text.lines_32 as list loop
				line := list.item
				output.wipe_out; output_2.wipe_out
				character_set := line.substring (1, 2)
				across line as uc loop
					if character_set.has (uc.item) then
						output_2.append_character (uc.item)
					end
				end
				core := optimal_core (line)
				matcher.set_pattern (agent repeated_character_in_set (character_set, line, output))
				matcher.set_source_text (line)
				matcher.find_all (Void)
				assert ("same output", output ~ output_2)
			end
		end

	test_xpath_parser
		note
			testing: "covers/{EL_XPATH_PARSER}.parse"
		local
			parser: EL_XPATH_PARSER; steps: LIST [STRING]; parsed_step: EL_PARSED_XPATH_STEP
			index_of_at, index_of_equal: INTEGER
		do
			create parser.make
			across Xdoc.Xpaths.split ('%N') as xpath loop
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

feature {NONE} -- Implementation

	append_to (start_index, end_index: INTEGER; output: ZSTRING)
		do
			output.append_substring_general (source_text, start_index, end_index)
		end

	prepare_source
		do
			create {STRING_8} source_text.make_empty
		end

	set_source_text (a_text: STRING_GENERAL)
		do
			source_text.keep_head (0)
			if attached {ZSTRING} a_text as zstr then
				zstr.append_to_general (source_text)
			else
				source_text.append (a_text)
			end
		end

	test_array_pattern (array_pattern: FUNCTION [like PARSE_ACTION, like all_of]; upper_limit: INTEGER)
		local
			number_list, actual_number_list: EL_ARRAYED_LIST [DOUBLE]; csv_list: ZSTRING
			manifest_text: STRING
		do
			create actual_number_list.make_from (Number.Doubles_list)
			if upper_limit = 3 then
				manifest_text := Text.doubles_array_manifest (Void)
			else
				manifest_text := Text.doubles_array_manifest (upper_limit)
				actual_number_list.keep_head (upper_limit)
			end
			create number_list.make (actual_number_list.count)

			lio.put_string ("doubles := " + manifest_text)
			lio.put_new_line

			create csv_list.make_empty

			set_source_text (manifest_text)
			if attached array_pattern (agent on_numeric (?, ?, csv_list)) as pattern then
				pattern.parse (source_text)
				if pattern.is_matched then
					across csv_list.split_list (',') as list loop
						if list.item.is_double then
							number_list.extend (list.item.to_double)
						end
					end
					assert ("parsed Eiffel numeric array OK", number_list ~ actual_number_list)
				else
					failed ("numeric_array_pattern: is_full_match OK")
				end
			end
		end

feature {NONE} -- Patterns

	array_close: like string_literal
		do
			Result := string_literal (">>")
		end

	array_open: like string_literal
		do
			Result := string_literal ("<<")
		end

	character_array_pattern (do_with_char: PROCEDURE [CHARACTER_32]): like all_of
		do
			Result := all_of (<<
				array_open,
				optional_white_space,
				one_of (<<
					array_close, -- Empty array
					all_of (<<
						quoted_character (do_with_char),
						while_not_p1_repeat_p2 (
							all_of (<< optional_white_space, array_close >>),
							all_of (<<
								all_of (<< optional_white_space, character_literal (','), optional_white_space >>),
								quoted_character (do_with_char)
							>>)
						)
					>>)
				>>)
			>>)
		end

	hash_table_pattern (append_name: like PARSE_ACTION): like all_of
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				string_literal ("HASH_TABLE"),
				character_literal ('['),
				class_name |to| append_name,
				character_literal (','),
				class_name |to| append_name,
				character_literal (']')
			>>)
		end

	numeric_array_pattern_1 (get_number: like PARSE_ACTION): like all_of
		do
			Result := all_of (<<
				array_open, optional_white_space,
				one_of (<<
					array_close, -- Empty array
					all_of (<<
						decimal_constant |to| get_number,
						zero_or_more (
							all_of (<<
								optional_white_space, character_literal (','), optional_white_space,
								decimal_constant |to| get_number
							>>)
						),
						optional_white_space,
						array_close
					>>)
				>>)
			>>)
		end

	numeric_array_pattern_2 (get_number: like PARSE_ACTION): like all_of
		do
			Result := all_of (<<
				array_open,
				optional_white_space,
				one_of (<<
					array_close, -- Empty array
					all_of (<<
						decimal_constant |to| get_number,
						while_not_p1_repeat_p2 (
							all_of (<< optional_white_space, array_close >>),
							all_of (<<
								all_of (<< optional_white_space, character_literal (','), optional_white_space >>),
								decimal_constant |to| get_number
							>>)
						)
					>>)
				>>)
			>>)
		end

	numeric_array_pattern_3 (get_number: like PARSE_ACTION): like all_of
		-- parse array with at least 2 items
		do
			Result := all_of (<<
				array_open,
				optional_white_space,
				all_of (<<
					decimal_constant |to| get_number,
					repeat_p1_until_p2 (
--						p1
						all_of (<<
							all_of (<< optional_white_space, character_literal (','), optional_white_space >>),
							decimal_constant |to| get_number
						>>),
--						p2
						all_of (<< optional_white_space, array_close >>)
					)
				>>)
			>>)
		end

	numeric_array_pattern_list: ARRAY [FUNCTION [like PARSE_ACTION, like all_of]]
		do
			Result := <<
				agent numeric_array_pattern_1,
				agent numeric_array_pattern_2,
				agent numeric_array_pattern_3
			>>
		end

	repeated_character_in_set (character_set: ZSTRING; a_source_text, output: ZSTRING): like one_or_more
		do
			Result := one_or_more (one_character_from (character_set))
			Result.set_action (agent output.append_substring_general (a_source_text, ?, ?))
		end

	xml_text_element_1 (a_action: like PARSE_ACTION): like all_of
		local
			any_text: like while_not_p1_repeat_p2
		do
			any_text := while_not_p1_repeat_p2 (string_literal ("</"), any_character)
			any_text.set_action_combined_p2 (a_action)
			if attached xml_identifier.referenced as tag_name then
				Result := all_of (<<
					character_literal ('<'),
					tag_name,
					character_literal ('>'),
					any_text,
					tag_name.back_reference,
					character_literal ('>')
				>>)
			end
		end

	xml_text_element_2 (a_action: like PARSE_ACTION): like all_of
		local
			any_text: like while_not_p_match_any
		do
			any_text := while_not_p_match_any (string_literal ("</"))
			any_text.set_leading_text_action (a_action)
			if attached xml_identifier.referenced as tag_name then
				Result := all_of (<<
					character_literal ('<'),
					tag_name,
					character_literal ('>'),
					any_text,
					tag_name.back_reference,
					character_literal ('>')
				>>)
			end
		end

	xml_text_element_list: ARRAY [FUNCTION [like PARSE_ACTION, like all_of]]
		do
			Result := << agent xml_text_element_1, agent xml_text_element_2 >>
		end

feature {NONE} -- Events handlers

	on_line (start_index, end_index: INTEGER; line_list: ARRAYED_LIST [STRING_GENERAL])
		do
			line_list.extend (source_text.substring (start_index, end_index))
		end

	on_numeric (start_index, end_index: INTEGER; output: ZSTRING)
		do
			if output.count > 0 then
				output.append_character (',')
			end
			output.append_substring_general (source_text, start_index, end_index)
		end

	on_prepare
		do
			Precursor
			prepare_source
			core := optimal_core (source_text)
		end

	on_quoted (str: STRING_GENERAL; output: ZSTRING)
		do
			output.append_string_general (str)
		end

	on_quoted_character (uc: CHARACTER_32; output: ZSTRING)
		do
			output.append_character (uc)
		end

	on_quoted_substring (start_index, end_index: INTEGER; output: ZSTRING)
		do
			output.wipe_out
			output.append_substring_general (source_text, start_index + 1, end_index - 1)
		end

feature {NONE} -- Internal attributes

	core: TP_OPTIMIZED_FACTORY
		-- core pattern factory

	source_text: STRING_GENERAL

feature {NONE} -- Constants

	Eiffel_character_array: STRING = "[
		<< 'A', '%/65/', '%N', '%'' >>
	]"

	Ireland: COUNTRY
		once
			create Result.make_default
			Result.set_name ("Ireland")
			Result.set_code ("ie")
			Result.set_population (4_766_073)
		end

	Name_susan: STRING = "Susan Miller"

	PARSE_ACTION: PROCEDURE [INTEGER, INTEGER]
		once
			Result := agent (start_index, end_index: INTEGER) do  end
		end

	XML_element: ZSTRING
		once
			Result := "<name>%S</name>"
		end

end