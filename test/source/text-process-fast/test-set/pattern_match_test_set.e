note
	description: "Test routines in libary cluster [./library/text-process.pattern_match.html Pattern-matching]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 8:32:59 GMT (Friday 28th October 2022)"
	revision: "1"

class
	PATTERN_MATCH_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

	EL_EIFFEL_TEXT_PATTERN_FACTORY_2
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("alpha_character_match", agent test_alpha_character_match)
			eval.call ("integer_match", agent test_integer_match)
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
			number: DOUBLE; boolean: BOOLEAN
		do
			set_optimal_core ("")
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
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/EL_MATCH_ONE_OR_MORE_TIMES_TP}.match_count",
						"covers/EL_MATCH_COUNT_WITHIN_BOUNDS_TP}.match_count",
						"covers/EL_STRING_8_NUMERIC_CHAR_TP}.match_count",
						"covers/EL_STRING_8_LITERAL_CHAR_TP}.match_count"
		local
			number: DOUBLE
		do
			set_optimal_core ("")
			across Numbers as n loop
				number := n.item
				assert ("matches_string_general OK", numeric_constant.matches_string_general (number.out))
			end
		end

feature {NONE} -- Constants

	Numbers: ARRAY [DOUBLE]
		once
			Result := << 1.23, 1, 10, 12.3, 12.3, 123, -1, -10, -1.23, -12.3, -123 >>
		end

end