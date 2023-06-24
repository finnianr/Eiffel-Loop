note
	description: "Test class [$source L1_UC_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 6:32:08 GMT (Saturday 24th June 2023)"
	revision: "12"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["expanded_string",					 agent test_expanded_string],
				["reusable_zstrings",				 agent test_reusable_zstrings],
				["l1_uc_string_conversion",		 agent test_l1_uc_string_conversion],
				["l1_uc_string_unicode_by_index", agent test_l1_uc_string_unicode_by_index]
			>>)
		end

feature -- Tests

	test_expanded_string
		-- TEXT_DATA_TEST_SET.test_expanded_string
		local
			ex: EXPANDED_STRING; s: STRING
		do
			s := "abc"
			ex.share (s)
			assert ("same hash_code", ex.hash_code = 6382179)
		end

	test_reusable_zstrings
		local
			s1, s2, s3, s4: ZSTRING
		do
			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("empty string", s1.is_empty)
				s1.append_string_general ("abc")
				across Reuseable.string as reuse2 loop
					s3 := reuse2.item
					assert ("s3 is new instance", s1 /= s3)
				end
			end
			across Reuseable.string as reuse loop
				s2 := reuse.item
				assert ("empty string", s2.is_empty)
				across Reuseable.string as reuse2 loop
					s4 := reuse2.item
				end
			end
			assert ("instance recycled", s1 = s2)
			assert ("nested instances recycled", s3 = s4)
		end

feature -- L1_UC_STRING tests

	test_l1_uc_string_conversion
		note
			testing: "covers/{SUBSTRING_32_ARRAY}.write, covers/{SUBSTRING_32_LIST}.append_character"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text.Russian_and_english)
			assert ("strings equal", Text.Russian_and_english ~ l1_uc.to_string_32)
		end

	test_l1_uc_string_unicode_by_index
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

feature {NONE} -- Constants

	Padded_euro: ZSTRING
		once

		end
end