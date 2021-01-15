note
	description: "Test [$source EL_UTF_CONVERTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-15 13:03:04 GMT (Friday 15th January 2021)"
	revision: "3"

class
	UTF_CONVERTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		do
			eval.call ("utf_8_substring_conversion", agent test_utf_8_substring_conversion)
		end

feature -- Test

	test_utf_8_substring_conversion
		local
			str_32, substring_32: STRING_32; utf_8: STRING_8
			c: EL_UTF_CONVERTER; i, leading_count, trailing_count: INTEGER
		do
			across text_lines as line loop
				str_32 := line.item
				from i := 1 until i > str_32.count or else str_32.code (i) > 0x7F  loop
					i := i + 1
				end
				leading_count := i - 1
				from i := str_32.count until i = 0 or else str_32.code (i) > 0x7F loop
					i := i - 1
				end
				trailing_count := str_32.count - i
				utf_8 := c.string_32_to_utf_8_string_8 (str_32)
				create substring_32.make_empty
				c.utf_8_substring_8_into_string_32 (utf_8, leading_count + 1, utf_8.count - trailing_count, substring_32)
				assert ("same string", str_32.substring (leading_count + 1, str_32.count - trailing_count) ~ substring_32)
			end
		end
end