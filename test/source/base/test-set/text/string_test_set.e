note
	description: "Test class [$source L1_UC_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-23 17:00:02 GMT (Friday 23rd June 2023)"
	revision: "11"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_SHARED_TEST_TEXT

	EL_SHARED_ZCODEC_FACTORY

	EL_DOCUMENT_CLIENT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["expanded_string",					 agent test_expanded_string],
				["reusable_zstrings",				 agent test_reusable_zstrings],
				["utf_8_adjusted",					 agent test_utf_8_adjusted],
				["utf_8_set_string",					 agent test_utf_8_set_string],
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

feature -- EL_UTF_8_STRING tests

	test_utf_8_adjusted
		-- STRING_TEST_SET.test_utf_8_adjusted
		note
			testing: "covers/{EL_UTF_8_STRING}.adjusted, covers/{EL_UTF_8_STRING}.unicode_count"
		local
			utf_8: EL_UTF_8_STRING; padded_string: ZSTRING
		do
			across << Text.Dollor_symbol, Text.Euro_symbol >> as symbol loop
				across << 1, 3 >> as length loop
					create padded_string.make_filled (' ', length.item)
					padded_string [length.item // 2 + 1] := symbol.item
					utf_8 := padded_string.to_utf_8 (True)
					assert ("is length", utf_8.unicode_count = length.item)

					if attached utf_8.adjusted (False) as str then
						assert ("is same symbol", str.is_character (symbol.item))
					end
				end
			end
		end

	test_utf_8_set_string
		-- STRING_TEST_SET.test_utf_8_set_string
		note
			testing: "covers/{EL_UTF_8_STRING}.adjusted, covers/{EL_UTF_8_STRING}.unicode_count"
		local
			utf_8, encoded: EL_UTF_8_STRING; padded_string: ZSTRING; latin_15: EL_DOCUMENT_NODE_STRING
			s32: EL_STRING_32_ROUTINES; latin_15_codec: EL_ZCODEC
		do
			create latin_15.make_default
			latin_15.set_latin_encoding (15)
			latin_15_codec := Codec_factory.codec (latin_15)
			create utf_8.make (0)

			across << create {ZSTRING}.make (0), create {STRING_32}.make (0) >> as type loop
				across << Text.Dollor_symbol, Text.Euro_symbol >> as symbol loop
					across << 1, 3 >> as length loop
						create padded_string.make_filled (' ', length.item)
						padded_string [length.item // 2 + 1] := symbol.item
						across << utf_8, latin_15 >> as list loop
							encoded := list.item
							encoded.wipe_out
							if encoded = Utf_8 then
								encoded.append (padded_string.to_utf_8 (True))

							elseif attached padded_string.as_encoded_8 (latin_15_codec) as str_8 then
								encoded.append (str_8)
							end
							if attached {ZSTRING} type.item as str then
								encoded.set_string (str, True)
								assert ("is same symbol", str.is_character (symbol.item))
							elseif attached {STRING_32} type.item as str then
								encoded.set_string_32 (str, True)
								assert ("is same symbol", s32.is_character (str, symbol.item))
							end
						end
					end
				end
			end
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