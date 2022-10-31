note
	description: "Test routines in libary cluster [./library/text-process.pattern_match.html Pattern-matching]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 9:51:42 GMT (Monday 31st October 2022)"
	revision: "3"

class
	PATTERN_MATCH_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_EIFFEL_TEXT_PATTERN_FACTORY_2
		undefine
			default_create
		end

	EL_SHARED_TEST_TEXT

	EL_SHARED_TEST_NUMBERS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("alpha_character_match", agent test_alpha_character_match)
			eval.call ("integer_match", agent test_integer_match)
			eval.call ("numbers_array_parsing", agent test_numbers_array_parsing)
			eval.call ("numeric_match", agent test_numeric_match)
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
			is_full_match: BOOLEAN; number_list: ARRAYED_LIST [DOUBLE]
		do
			create number_list.make (10)
			source_string_8 := Text.doubles_array_manifest
			set_optimal_core (source_string_8)
			if attached numeric_array_pattern (number_list) as pattern then

				pattern.match (0, source_string_8)
				is_full_match := pattern.is_matched and pattern.count = source_string_8.count
				assert ("numeric_array_pattern: is_full_match OK", is_full_match)
				pattern.call_actions (1, source_string_8.count)
				assert ("parsed Eiffel numeric array OK", number_list.to_array ~ Number.Doubles_list)
			end
		end

	test_numeric_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/EL_MATCH_ONE_OR_MORE_TIMES_TP}.match_count",
						"covers/EL_MATCH_COUNT_WITHIN_BOUNDS_TP}.match_count",
						"covers/EL_STRING_8_NUMERIC_CHAR_TP}.match_count",
						"covers/EL_STRING_8_LITERAL_CHAR_TP}.match_count"
		local
			double: DOUBLE
		do
			set_optimal_core ("")
			across Number.Doubles_list as n loop
				double := n.item
				assert ("matches_string_general OK", decimal_constant.matches_string_general (double.out))
			end
		end

feature {NONE} -- Patterns

	numeric_array_pattern (list: ARRAYED_LIST [DOUBLE]): like all_of
		do
			Result := all_of (<<
				string_literal ("<<"), maybe_white_space,
				decimal_constant |to| agent on_numeric (?, ?, list),
				zero_or_more (
					all_of (<<
						maybe_white_space, character_literal (','), maybe_white_space,
						decimal_constant |to| agent on_numeric (?, ?, list)
					>>)
				),
				maybe_white_space,
				string_literal (">>")
			>>)
		end

feature {NONE} -- Parse events handlers

	on_numeric (start_index, end_index: INTEGER; list: ARRAYED_LIST [DOUBLE])
		local
			str: STRING
		do
			str := source_string_8.substring (start_index, end_index)
			if str.is_double then
				list.extend (str.to_double)
			end
		end

feature {NONE} -- Internal attributes

	source_string_8: STRING_8

end