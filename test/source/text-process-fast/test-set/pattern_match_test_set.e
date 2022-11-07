note
	description: "Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 10:47:28 GMT (Monday 7th November 2022)"
	revision: "8"

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

	EL_MODULE_LIO

	EL_SHARED_TEST_TEXT

	EL_SHARED_TEST_NUMBERS

	EL_SHARED_TEST_XML_DATA

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("alpha_character_match", agent test_alpha_character_match)
			eval.call ("integer_match", agent test_integer_match)
			eval.call ("numbers_array_parsing", agent test_numbers_array_parsing)
			eval.call ("numeric_match", agent test_numeric_match)
			eval.call ("pyxis_attribute_parser", agent test_pyxis_attribute_parser)
			eval.call ("quoted_c_string", agent test_quoted_c_string)
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
						"covers/{EL_MATCH_CHAR_IN_ASCII_RANGE_TP}.match_count"
		local
			number_list: ARRAYED_LIST [DOUBLE]; csv_list: ZSTRING
		do
			create number_list.make (10)
			create csv_list.make_empty
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

			source_line_1 := XML.pyxis_attributes_line (XML.Attribute_table)
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
				across XML.Attribute_table as table loop
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
			across XML.Xpaths.split ('%N') as xpath loop
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

	numeric_array_pattern (get_number: PROCEDURE [INTEGER, INTEGER]): like all_of
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

feature {NONE} -- Events handlers

	on_numeric (start_index, end_index: INTEGER; source: STRING_GENERAL; output: ZSTRING)
		do
			if output.count > 0 then
				output.append_character (',')
			end
			output.append_string_general (source.substring (start_index, end_index))
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

end