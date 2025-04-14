note
	description: "Test ${EL_DOCUMENT_NODE_STRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 8:38:03 GMT (Monday 14th April 2025)"
	revision: "15"

class
	DOCUMENT_NODE_STRING_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

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
				["utf_8_set_string",		agent test_utf_8_set_string],
				["xpath_set_node_scan",	agent test_xpath_set_node_scan]
			>>)
		end

feature -- Tests

	test_utf_8_set_string
		-- DOCUMENT_NODE_STRING_TEST_SET.test_utf_8_set_string
		note
			testing: "[
				covers/{EL_UTF_8_STRING}.set_string,
				covers/{EL_UTF_8_STRING}.set_string_32,
				covers/{EL_UTF_8_STRING}.adjusted,
				covers/{EL_UTF_8_STRING}.unicode_count,
				covers/{EL_DOCUMENT_NODE_STRING}.set_string,
				covers/{EL_DOCUMENT_NODE_STRING}.set_string_32,
				covers/{EL_IMMUTABLE_STRING_MANAGER}.set_adjusted_item
			]"
		local
			utf_8, encoded: EL_UTF_8_STRING; padded_string: ZSTRING; latin_15: EL_DOCUMENT_NODE_STRING
			s32: EL_STRING_32_ROUTINES; s8: EL_STRING_8_ROUTINES; latin_15_codec: EL_ZCODEC
		do
			create latin_15.make_default
			latin_15.set_latin_encoding (15)
			latin_15_codec := Codec_factory.codec (latin_15)
			create utf_8.make (0)

			across << create {ZSTRING}.make (0), create {STRING_32}.make (0), create {STRING_8}.make (0) >> as type loop
				across << Text.Dollor_symbol, Text.Mu_symbol, Text.Euro_symbol >> as symbol loop
					across << 1, 3 >> as length loop
						create padded_string.make_filled (' ', length.item)
						padded_string [length.item // 2 + 1] := symbol.item
						across << utf_8, latin_15 >> as list loop
							encoded := list.item
							encoded.wipe_out
							if encoded = Utf_8 then
								encoded.append (padded_string.to_utf_8)

							elseif attached padded_string.as_encoded_8 (latin_15_codec) as str_8 then
								encoded.append (str_8)
							end
							assert ("is length", encoded.unicode_count = length.item)

							if attached {ZSTRING} type.item as str then
								encoded.set_string (str, True)
								assert ("is same symbol", str.is_character (symbol.item))
								assert_same_string (Void, str, encoded.adjusted (False))

							elseif attached {STRING_32} type.item as str then
								encoded.set_string_32 (str, True)
								assert ("is same symbol", super_32 (str).is_character (symbol.item))
								assert_same_string (Void, str, encoded.adjusted_32 (False))

							elseif symbol.item.is_character_8 and then attached {STRING_8} type.item as str then
								encoded.set_string_8 (str, True)
								assert ("is same symbol", super_8 (str).is_character (symbol.item.to_character_8))
								assert_same_string (Void, str, encoded.adjusted_8 (False))
							end
						end
					end
				end
			end
		end

	test_xpath_set_node_scan
		-- DOCUMENT_NODE_STRING_TEST_SET.test_xpath_set_node_scan
		do
			do_test ("display_xpath_set", 1110527184, agent display_xpath_set, ["linguistic-analysis.smil"])
			do_test ("display_xpath_set", 133799911, agent display_xpath_set, ["download-page.xhtml"])
		end

feature {NONE} -- Implementation

	display_xpath_set (file_name: STRING)
		local
			compiler: EL_XML_XPATH_SET_COMPILER
		do
			create compiler.make_from_file ("XML/creatable/" + file_name)
			across compiler.sorted_xpath_set as list loop
				lio.put_line (list.item)
			end
		end
end