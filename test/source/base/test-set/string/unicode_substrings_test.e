note
	description: "Test class [$source EL_UNICODE_SUBSTRINGS] and [$source EL_EXTENDABLE_UNICODE_SUBSTRINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 14:58:31 GMT (Thursday 3rd December 2020)"
	revision: "1"

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
			eval.call ("unicode_substrings", agent test_unicode_substrings)
		end

feature -- Tests

	test_unicode_substrings
		note
			testing: "covers/{EL_UNICODE_SUBSTRINGS}.write", "covers/{EL_UNICODE_SUBSTRINGS}.code_item",
				"covers/{EL_EXTENDABLE_UNICODE_SUBSTRINGS}.append_code"
		local
			substrings: EL_EXTENDABLE_UNICODE_SUBSTRINGS
			code: NATURAL; latin_1: STRING; output: STRING_32
		do
			create substrings.make
			create latin_1.make (Text_russian_and_english.count)
			across Text_russian_and_english as char loop
				code := char.item.natural_32_code
				if code > 0xFF then
					substrings.append_code (code, char.cursor_index)
					latin_1.append_character (Unencoded_character)
				else
					latin_1.append_code (code)
				end
			end
			substrings.finalize

			create output.make (latin_1.count)
			across latin_1 as c loop
				output.append_code (c.item.natural_32_code)
			end
			substrings.write (output.area, 0)
			assert ("strings equal", Text_russian_and_english ~ output)

--			Test binary search in `code_item'
			across Text_russian_and_english as char loop
				code := char.item.natural_32_code
				if code > 0xFF then
					assert ("same code", code = substrings.code_item (char.cursor_index))
				end
			end
		end

end