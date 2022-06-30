note
	description: "String iteration cursor test SET"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 8:22:25 GMT (Thursday 30th June 2022)"
	revision: "1"

class
	STRING_ITERATION_CURSOR_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_STRING_32_CURSOR

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("measurements", agent test_measurements)
			eval.call ("status_query", agent test_status_query)
			eval.call ("transforms", agent test_transforms)
		end

feature -- Tests

	test_measurements
		note
			testing:
				"covers/{EL_STRING_8_ITERATION_CURSOR}.leading_occurrences",
				"covers/{EL_STRING_8_ITERATION_CURSOR}.leading_white_count",
				"covers/{EL_STRING_8_ITERATION_CURSOR}.trailing_white_count",

				"covers/{EL_STRING_32_ITERATION_CURSOR}.leading_occurrences",
				"covers/{EL_STRING_32_ITERATION_CURSOR}.leading_white_count",
				"covers/{EL_STRING_32_ITERATION_CURSOR}.trailing_white_count",
				"covers/{EL_STRING_32_ITERATION_CURSOR}.latin_1_count"
		do
			assert ("1 leading tab", cursor_8 (padded_8 ('%T')).leading_occurrences ('%T') = 1)
			assert ("1 leading space", cursor_8 (padded_8 (' ')).leading_white_count = 1)
			assert ("0 leading space", cursor_8 (padded_8 ('-')).leading_white_count = 0)
			assert ("1 trailing space", cursor_8 (padded_8 (' ')).trailing_white_count = 1)
			assert ("0 trailing space", cursor_8 (padded_8 ('-')).trailing_white_count = 0)

			assert ("1 leading tab", cursor_32 (padded_32 ('%T')).leading_occurrences ('%T') = 1)
			assert ("1 leading space", cursor_32 (padded_32 (' ')).leading_white_count = 1)
			assert ("0 leading space", cursor_32 (padded_32 ('-')).leading_white_count = 0)
			assert ("1 trailing space", cursor_32 (padded_32 (' ')).trailing_white_count = 1)
			assert ("0 trailing space", cursor_32 (padded_32 ('-')).trailing_white_count = 0)
			assert ("3 latin-1 characters", cursor_32 (padded_32 (Euro)).latin_1_count = 3)
		end

	test_status_query
		note
			testing:
				"covers/{EL_STRING_8_ITERATION_CURSOR}.is_ascii_substring",
				"covers/{EL_STRING_8_ITERATION_CURSOR}.all_ascii",
				"covers/{EL_STRING_8_ITERATION_CURSOR}.is_eiffel_lower",
				"covers/{EL_STRING_8_ITERATION_CURSOR}.is_eiffel_upper"
		do
			if attached padded_8 ((0xA9).to_character_8) as non_ascii_padding then
				assert ("is ascii substring", cursor_8 (non_ascii_padding).is_ascii_substring (2, 4))
				assert ("not is ascii substring", not cursor_8 (non_ascii_padding).is_ascii_substring (2, 5))
				assert ("not all ascii characters", not cursor_8 (non_ascii_padding).all_ascii)
			end
			assert ("all ascii characters", cursor_8 (padded_8 ('%T')).all_ascii)

			if attached padded_8 ('%T').shared_substring (2, 4) as abc then
				assert ("abc", abc.same_string ("abc"))
				assert ("is eiffel lower", cursor_8 (abc).is_eiffel_lower)
				assert ("not is eiffel upper", not cursor_8 (abc).is_eiffel_upper)
			end
		end

	test_transforms
		note
			testing: "covers/{EL_STRING_8_ITERATION_CURSOR}.filtered"
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			assert ("is abc", cursor_8 (padded_8 ('%T')).filtered (agent c.is_a_to_z_lower) ~ "abc" )
		end

feature {NONE} -- Implementation

	padded_32 (c: CHARACTER_32): IMMUTABLE_STRING_32
		local
			str: STRING_32; outer: IMMUTABLE_STRING_32
		do
			str := "abc"
			across 1 |..| 2 as n loop
				str.append_character (c)
				str.prepend_character (c)
			end
			outer := str
			Result := outer.shared_substring (2, 6)
		end

	padded_8 (c: CHARACTER_8): IMMUTABLE_STRING_8
		local
			str: STRING_8; outer: IMMUTABLE_STRING_8
		do
			str := "abc"
			across 1 |..| 2 as n loop
				str.append_character (c)
				str.prepend_character (c)
			end
			outer := str
			Result := outer.shared_substring (2, 6)
		end

feature {NONE} -- Constants

	Euro: CHARACTER_32
		once
			Result := (0x20AC).to_character_32
		end
end