note
	description: "Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 14:30:43 GMT (Thursday 10th November 2022)"
	revision: "10"

class
	PATTERN_MATCH_TEST_SET

inherit
	EL_EQA_TEST_SET
		redefine
			on_prepare
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY_2
		undefine
			default_create
		end

	EL_MODULE_LIO; EL_MODULE_XML

	EL_SHARED_TEST_TEXT

	EL_SHARED_TEST_NUMBERS

	EL_SHARED_TEST_XDOC_DATA

	EL_STRING_8_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("alpha_character_match", agent test_alpha_character_match)
			eval.call ("back_reference_match", agent test_back_reference_match)
			eval.call ("integer_match", agent test_integer_match)
			eval.call ("numbers_array_parsing", agent test_numbers_array_parsing)
			eval.call ("numeric_match", agent test_numeric_match)
			eval.call ("pyxis_attribute_parser", agent test_pyxis_attribute_parser)
			eval.call ("quoted_c_string", agent test_quoted_c_string)
			eval.call ("recursive_match", agent test_recursive_match)
			eval.call ("string_substitution", agent test_string_substitution)
			eval.call ("xpath_parser", agent test_xpath_parser)
		end

feature -- Test

	test_alpha_character_match
		note
			testing: "covers/{EL_ZSTRING_ALPHA_CHAR_TP}.match_count"
		local
			str: ZSTRING
		do
			str := "1a"
			set_optimal_core (str)
			if attached letter as p then
				p.match (0, str)
				assert ("no match", not p.is_matched)
				p.match (1, str)
				assert ("matched", p.is_matched)
			end
		end

	test_back_reference_match
		note
			testing: "covers/{EL_BACK_REFERENCE_MATCH_TP}.match_count",
				"covers/{EL_REFERENCE_MATCH_TP}.match_count",
				"covers/{EL_MATCH_P2_WHILE_NOT_P1_MATCH_TP}.match_count",
				"covers/{EL_MATCH_ANY_WHILE_NOT_P_MATCH_TP}.match_count"
		local
			output: ZSTRING; pattern: like all_of
			xml_text_element: like xml_text_element_list.item
		do
			create output.make_empty
			across xml_text_element_list as list loop
				xml_text_element := list.item
				across << Empty_string_8, Name_susan >> as name loop
					across source_strings as str loop
						if attached str.item as source then
							set_optimal_core (source)
							XML.value_element_markup ("name", name.item).append_to_general (source)
							output.wipe_out
							pattern := xml_text_element (agent output.append_substring_general (source, ?, ?))
							pattern.parse (source)
							if pattern.is_matched then
								assert ("match_count OK", name.item ~ output)
							else
								assert ("parse OK", False)
							end
						end
					end
				end
			end
		end

	test_integer_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/EL_MATCH_ONE_OR_MORE_TIMES_TP}.match_count",
						"covers/EL_MATCH_COUNT_WITHIN_BOUNDS_TP}.match_count",
						"covers/EL_STRING_8_NUMERIC_CHAR_TP}.match_count",
						"covers/EL_STRING_8_LITERAL_CHAR_TP}.match_count"
		local
			double: DOUBLE; boolean: BOOLEAN
		do
			set_optimal_core ("")
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

	test_numbers_array_parsing
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/{EL_LITERAL_TEXT_PATTERN}.match_count",
						"covers/{EL_MATCH_ZERO_OR_MORE_TIMES_TP}.match_count",
						"covers/{EL_MATCH_ANY_CHAR_IN_SET_TP}.match_count",
						"covers/{EL_LITERAL_CHAR_TP}.match_count",
						"covers/{EL_MATCH_CHAR_IN_ASCII_RANGE_TP}.match_count",
						"covers/{EL_MATCH_LOOP_TP}.internal_call_actions",
						"covers/{EL_MATCH_LOOP_TP}.match"
		local
			number_list: ARRAYED_LIST [DOUBLE]; csv_list: ZSTRING
			numeric_array_pattern: like numeric_array_pattern_list.item
		do
			create number_list.make (10)
			create csv_list.make_empty
			across numeric_array_pattern_list as array_pattern loop
				numeric_array_pattern := array_pattern.item
				across source_strings as str loop
					set_optimal_core (str.item)
					str.item.append (Text.doubles_array_manifest)
					if attached numeric_array_pattern (agent on_numeric (?, ?, str.item, csv_list)) as pattern then
						csv_list.wipe_out; number_list.wipe_out
						pattern.parse (str.item)
						if pattern.is_matched then
							across csv_list.split (',') as list loop
								if list.item.is_double then
									number_list.extend (list.item.to_double)
								end
							end
							assert ("parsed Eiffel numeric array OK", number_list.to_array ~ Number.Doubles_list)
						else
							assert ("numeric_array_pattern: is_full_match OK", False)
						end
					end
				end
			end
		end

	test_numeric_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/EL_MATCH_ONE_OR_MORE_TIMES_TP}.match_count",
						"covers/EL_MATCH_COUNT_WITHIN_BOUNDS_TP}.match_count",
						"covers/EL_STRING_8_NUMERIC_CHAR_TP}.match_count",
						"covers/EL_STRING_8_LITERAL_CHAR_TP}.match_count"
		do
			across source_strings as str loop
				set_optimal_core (str.item)
				across Number.Doubles_list as double loop
					str.item.keep_head (0)
					str.item.append (double.item.out)
					assert ("matches_string_general OK", decimal_constant.matches_string_general (str.item))
				end
			end
		end

	test_pyxis_attribute_parser
		local
			parser: PYXIS_ATTRIBUTE_TEST_PARSER; index: INTEGER
			leading_tabs, trailing_spaces, source_line_1, source_line_2: STRING
		do
			create leading_tabs.make_filled ('%T', 2)
			create trailing_spaces.make_filled (' ', 2)

			source_line_1 := Xdoc.pyxis_attributes_line (Xdoc.Attribute_table)
			source_line_2 := leading_tabs + source_line_1 + trailing_spaces

			create parser.make

			across << source_line_1, source_line_2 >> as source loop
				if source.item.starts_with (leading_tabs) then
					parser.set_substring_source_text (source.item, 3, source.item.count - 2)
				else
					parser.set_source_text (source.item)
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
						assert ("has key " + table.key, False)
					end
				end
			end
		end

	test_quoted_c_string
		note
			testing: "covers/{EL_MATCH_QUOTED_C_LANG_STRING_TP}.match"
		local
			pattern: like quoted_c_lang_string
			output, content: ZSTRING
		do
			create content.make_empty
			create output.make_empty
			across source_strings as str loop
				set_optimal_core (str.item)
				str.item.append ("[
					"-\n-\"-\\"
				]")
				output.wipe_out
				pattern := quoted_c_lang_string ('"', agent on_quoted (?, output))
				pattern.set_action (agent on_quoted_substring (?, ?, str.item, content))
				pattern.parse (str.item)
				if pattern.is_matched then
					assert ("string without quotes", content.enclosed ('"', '"').same_string (str.item))
					assert ("same string", output.same_string ("-%N-%"-\"))
				else
					assert ("matched", False)
				end
			end
		end

	test_recursive_match
		note
			testing: "covers/{EL_RECURSIVE_TEXT_PATTERN}.match"
		local
			eiffel_type: like class_type; type_string: ZSTRING
		do
			eiffel_type := class_type
			across Text.Eiffel_type_declarations.split ('%N') as line loop
				type_string := line.item
				assert ("match OK", type_string.matches (eiffel_type))
				type_string := type_string + " X"
				assert ("not match OK", not type_string.matches (eiffel_type))
			end
		end

	test_string_substitution
		note
			testing: "covers/{EL_SUBST_VARIABLE_PARSER}.parse",
					"covers/{EL_SUBST_VARIABLE_PARSER}.set_variables_from_object",
					"covers/{EL_SUBST_VARIABLE_PARSER}.set_variables_from_array"
		local
			template_list: ARRAY [EL_SUBSTITUTION_TEMPLATE]
			target_text: STRING
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
							template.item.set_variables_from_object (ireland)
						else
							template.item.set_variables_from_array (<<
								[Text.Country.name, Ireland.name],
								[Text.Country.code, Ireland.code],
								[Text.Country.population, Ireland.population]
							>>)
						end
						assert ("same string", template.item.substituted.same_string (target_text))
					end
				end
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

	source_strings: ARRAY [STRING_GENERAL]
		do
			Result := << create {ZSTRING}.make_empty, create {STRING_8}.make_empty, create {STRING_32}.make_empty >>
		end

feature {NONE} -- Patterns

	numeric_array_pattern_list: ARRAY [FUNCTION [PROCEDURE [INTEGER, INTEGER], like all_of]]
		do
			Result := << agent numeric_array_pattern_1, agent numeric_array_pattern_2 >>
		end

	numeric_array_pattern_1 (get_number: PROCEDURE [INTEGER, INTEGER]): like all_of
		do
			Result := all_of (<<
				string_literal ("<<"), white_space,
				decimal_constant |to| get_number,
				zero_or_more (
					all_of (<<
						optional_white_space, character_literal (','), optional_white_space,
						decimal_constant |to| get_number
					>>)
				),
				optional_white_space,
				string_literal (">>")
			>>)
		end

	numeric_array_pattern_2 (get_number: PROCEDURE [INTEGER, INTEGER]): like all_of
		do
			Result := all_of (<<
				string_literal ("<<"),
				optional_white_space,
				one_of (<<
					string_literal (">>"), -- Empty array
					all_of (<<
						decimal_constant |to| get_number,
						while_not_p1_repeat_p2 (
							all_of (<< optional_white_space, string_literal (">>") >>),
							all_of (<<
								all_of (<< optional_white_space, character_literal (','), optional_white_space >>),
								decimal_constant |to| get_number
							>>)
						)
					>>)
				>>)
			>>)
		end

	xml_text_element_list: ARRAY [FUNCTION [PROCEDURE [INTEGER, INTEGER], like all_of]]
		do
			Result := << agent xml_text_element_1, agent xml_text_element_2 >>
		end

	xml_text_element_1 (a_action: PROCEDURE [INTEGER, INTEGER]): like all_of
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

	xml_text_element_2 (a_action: PROCEDURE [INTEGER, INTEGER]): like all_of
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

feature {NONE} -- Events handlers

	on_numeric (start_index, end_index: INTEGER; source: STRING_GENERAL; output: ZSTRING)
		do
			if output.count > 0 then
				output.append_character (',')
			end
			output.append_substring_general (source, start_index, end_index)
		end

	on_prepare
		do
			Precursor
		end

	on_quoted (str: STRING_GENERAL; output: ZSTRING)
		do
			output.append_string_general (str)
		end

	on_quoted_substring (start_index, end_index: INTEGER; source: STRING_GENERAL; output: ZSTRING)
		do
			output.wipe_out
			output.append_substring_general (source, start_index, end_index)
		end

feature {NONE} -- Constants

	Ireland: COUNTRY
		once
			create Result.make_default
			Result.set_name ("Ireland")
			Result.set_code ("ie")
			Result.set_population (4_766_073)
		end

	Name_susan: STRING = "Susan Miller"
end