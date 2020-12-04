note
	description: "Test class [$source EL_UNICODE_SUBSTRINGS] and [$source EL_EXTENDABLE_UNICODE_SUBSTRINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-04 17:05:46 GMT (Friday 4th December 2020)"
	revision: "2"

class
	UNICODE_SUBSTRINGS_TEST

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

	EL_MODULE_STRING_32

	EL_ZCODE_CONVERSION undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion", agent test_conversion)
			eval.call ("unicode_by_index", agent test_unicode_by_index)
		end

feature -- Tests

	test_conversion
		note
			testing: "covers/{EL_UNICODE_SUBSTRINGS}.write", "covers/{EL_EXTENDABLE_UNICODE_SUBSTRINGS}.append_code"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text_russian_and_english)
			assert ("strings equal", Text_russian_and_english ~ l1_uc.to_string_32)
		end

	test_unicode_by_index
		note
			testing: "covers/{EL_UNICODE_SUBSTRINGS}.code_item",
				"covers/{EL_EXTENDABLE_UNICODE_SUBSTRINGS}.append_code"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text_russian_and_english)

--			Test binary search in `code_item'
			across Text_russian_and_english as char loop
				code := char.item.natural_32_code
				if code > 0xFF then
					assert ("same code", code = l1_uc.unicode (char.cursor_index))
				end
			end
		end

end