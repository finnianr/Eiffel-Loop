note
	description: "[
		Test `UC_UTF8_STRING}.replace_substring_all' distributed in EiffelStudio version 15.01.9.6535
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 14:34:14 GMT (Saturday 31st December 2022)"
	revision: "10"

class
	UC_UTF8_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
		end

feature -- Test routines

	test_replace_substring_all

		note
			testing: "covers/{UC_UTF8_STRING}.replace_substring_all"
		local
			str_32, original_32, new_32: STRING_32
			str_utf8, original_utf8, new_utf8: UC_UTF8_STRING
			readable_str_utf8: READABLE_STRING_GENERAL
		do
			create str_32.make_from_string (Hex_10_pinyin)
			create str_utf8.make_from_string_general (Hex_10_pinyin)

			create original_32.make_empty
			original_32.append_code (Hex_10_pinyin.code (3))
			create original_utf8.make_empty
			original_utf8.append_item_code (Hex_10_pinyin.code (3).to_integer_32)

			create new_32.make_from_string (Hex_10_chinese)
			create new_utf8.make_from_string_general (Hex_10_chinese)

			str_32.replace_substring_all (original_32, new_32)
			str_utf8.replace_substring_all (original_utf8, new_utf8)

			readable_str_utf8 := str_utf8 -- Workaround for `to_string_32' visibility issue
			assert ("same result", readable_str_utf8.to_string_32 ~ str_32)
		end

feature {NONE} -- Constants

	Hex_10_chinese: STRING_32 = "小畜"

	Hex_10_pinyin: STRING_32 = "Xiǎo Chù"

end