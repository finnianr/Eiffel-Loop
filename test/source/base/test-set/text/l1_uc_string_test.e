note
	description: "Test class [$source L1_UC_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	L1_UC_STRING_TEST

inherit
	EL_EQA_TEST_SET

	EL_ZCODE_CONVERSION undefine default_create end

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion", agent test_conversion)
			eval.call ("unicode_by_index", agent test_unicode_by_index)
		end

feature -- Tests

	test_conversion
		note
			testing: "covers/{SUBSTRING_32_ARRAY}.write, covers/{SUBSTRING_32_LIST}.append_character"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text.Russian_and_english)
			assert ("strings equal", Text.Russian_and_english ~ l1_uc.to_string_32)
		end

	test_unicode_by_index
		note
			testing: "covers/{SUBSTRING_32_ARRAY}.code_item, covers/{SUBSTRING_32_LIST}.append_character"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text.Russian_and_english)

--			Test binary search in `code_item'
			across Text.Russian_and_english as char loop
				code := char.item.natural_32_code
				if code > 0xFF then
					assert ("same code", code = l1_uc.unicode (char.cursor_index))
				end
			end
		end

end