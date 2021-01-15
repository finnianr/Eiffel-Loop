note
	description: "Test [$source EL_UTF_CONVERTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-14 16:36:45 GMT (Thursday 14th January 2021)"
	revision: "2"

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
			c: EL_UTF_CONVERTER
		do
			across Text_lines as line loop
				-- Skip Russian text
				if line.cursor_index > 1 then
					str_32 := line.item
					utf_8 := c.string_32_to_utf_8_string_8 (str_32)
					str_32.remove_head (2)
					str_32.remove_tail (2)
					create substring_32.make_empty
					c.utf_8_substring_8_into_string_32 (utf_8, 3, utf_8.count - 2, substring_32)
--					c.utf_8_string_8_into_string_32 (utf_8.substring (3, utf_8.count - 2), substring_32)
					assert ("same string", str_32 ~ substring_32)
				end
			end
		ensure
			line_2_starts_with_W: Text_lines.i_th (2).item (1) = 'W'
		end
end