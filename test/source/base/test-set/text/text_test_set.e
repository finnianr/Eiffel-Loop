note
	description: "Test string escaping and other text related tests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-12 12:22:51 GMT (Wednesday 12th April 2023)"
	revision: "19"

class
	TEXT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING; EL_MODULE_FORMAT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_TEST_TEXT

	EL_SHARED_ESCAPE_TABLE

	EL_SHARED_ZCODEC_FACTORY

	STRING_HANDLER undefine default_create end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["bash_escape",							 agent test_bash_escape],
				["convert_string_to_makeable",		 agent test_convert_string_to_makeable],
				["convert_string_type_descriptions", agent test_convert_string_type_descriptions],
				["encodeable_as_string_8",				 agent test_encodeable_as_string_8],
				["encoding_conversion",					 agent test_encoding_conversion],
				["number_formatting",					 agent test_number_formatting],
				["python_escape",							 agent test_python_escape],
				["substitution_marker_unescape",		 agent test_substitution_marker_unescape],
				["unescape",								 agent test_unescape]
			>>)
		end

feature -- Tests

	test_bash_escape
		-- TEXT_TEST_SET.test_bash_escape
		local
			escaper: EL_STRING_ESCAPER [ZSTRING]; escaper_32: EL_STRING_ESCAPER [STRING_32]
		do
			create escaper.make (Escape_table.bash) ; create escaper_32.make (Escape_table.bash)
			escape_test ("BASH", escaper, escaper_32)
		end

	test_convert_string_to_makeable
		-- TEXT_TEST_SET.test_convert_string_to_makeable
		note
			testing:	"covers/{EL_STRING_CONVERSION_TABLE}.is_convertible",
			 	"covers/{EL_STRING_CONVERSION_TABLE}.make_from_zcode_area"
		local
			encoding: EL_ENCODING; uuid: EL_UUID
			name: IMMUTABLE_STRING_8; uuid_string: STRING
		do
			name := "UTF-8"
			create encoding.make_from_name (name)
			assert ("is convertible", Convert_string.is_convertible (name, encoding.generating_type))
			assert ("same encoding", encoding ~ Convert_string.to_type (name, encoding.generating_type))

			create uuid.make_from_string ("A325754F-7BEB-44B6-937C-CC7EBDDA764F")
			uuid_string := uuid.to_string
			assert ("is convertible", Convert_string.is_convertible (uuid_string, uuid.generating_type))
			assert ("same uuid", uuid ~ Convert_string.to_type (uuid_string, uuid.generating_type))
		end

	test_convert_string_type_descriptions
		-- TEXT_TEST_SET.test_convert_string_type_descriptions
		note
			testing: "covers/{EL_READABLE_STRING_GENERAL_TO_TYPE}.new_type_description"
		do
			if attached crc_generator as crc then
				across Convert_string.type_list as list loop
					if attached Convert_string.type_descripton (list.item) as description then
						crc.add_string_8 (description)
						lio.put_labeled_string (list.item.name, description)
						lio.put_new_line
					end
				end
				if crc.checksum /= 1956217266 then
					lio.put_natural_field ("Actual checksum", crc.checksum)
					lio.put_new_line
					assert ("Expected descriptions", False)
				end
			end
		end

	test_encodeable_as_string_8
		-- TEXT_TEST_SET.test_encodeable_as_string_8
		local
			zstr: ZSTRING; codec: EL_ZCODEC
			first_latin, first_windows: BOOLEAN
		do
			if attached crc_generator as crc then
				across Text.lines as line loop
					zstr := line.item
					crc.add_string (zstr)
					lio.put_labeled_string ("LINE", zstr)
					lio.put_new_line
					first_latin := True; first_windows := True
					across Text.all_encodings as encoding loop
						codec := Codec_factory.codec_by (encoding.item)
						if codec.is_encodeable_as_string_8 (zstr, 1, zstr.count) then
							crc.add_natural (codec.id)
							if first_latin and codec.id <= 15 then
								lio.put_natural_field ("Latin", codec.id)
								first_latin := False
							elseif first_windows and codec.id > 1000 then
								lio.put_new_line
								lio.put_natural_field ("Windows", codec.id)
								first_windows := False
							else
								lio.put_string (", ")
								lio.put_natural (codec.id)
							end
						end
					end
					lio.put_new_line_x2
				end
				assert ("is_encodeable_as_string_8 OK", crc.checksum = 4117255750)
			end
		end

	test_encoding_conversion
		-- TEXT_TEST_SET.test_encoding_conversion
		local
			buffer: EL_STRING_8_IO_MEDIUM; encoding: EL_ENCODING
			zstr, name: ZSTRING; latin_id: INTEGER
		do
			create buffer.make (100)
			across Text.lines as line loop
				if line.item.starts_with (Latin) then
					zstr := line.item
					name := zstr.substring_to (':', default_pointer)
					name.replace_substring_general ("ISO-8859", 1, Latin.count)
					create encoding.make_from_name (name)
					buffer.wipe_out
					if attached Codec_factory.codec (encoding) as codec then
						lio.put_labeled_string ("Codec", codec.name)
						lio.put_new_line
						codec.write_encoded (zstr, buffer)
						if zstr.count ~ buffer.text.count then
							if codec.id = Codec_factory.zstring_codec.id then
								assert ("same string_8", zstr.area.same_items (buffer.text.area, 0, 0, zstr.count))
							else
								assert ("same encoded string_8", zstr.as_encoded_8 (codec) ~ buffer.text)
							end
						else
							assert ("same count", False)
						end
					else
						assert ("Found matching codec", False)
					end
				end
			end
		end

	test_number_formatting
		-- TEXT_TEST_SET.test_number_formatting
		note
			testing: "covers/{EL_FORMAT_ROUTINES}.internal_integer"
		local
			padding, formatted: STRING; width: INTEGER
			zero_padded: BOOLEAN; padding_character: CHARACTER
			pi: DOUBLE
		do
--			Integer formatting
			across << True, False >> as bool loop
				zero_padded := bool.item
				across 1 |..| 10 as n loop
					width := n.item
					if zero_padded then
						padding_character := '0'
						formatted := Format.zero_padded_integer (1, width)
					else
						padding_character := ' '
						formatted := Format.padded_integer (1, width)
					end
					create padding.make_filled (padding_character, width - 1)
					assert_same_string (Void, formatted, padding + "1")
				end
			end
--			Double formatting
			assert_same_string (Void, "3.142", Format.double ({DOUBLE_MATH}.Pi, 3, 3) )
		end

	test_python_escape
		-- TEXT_TEST_SET.test_python_escape
		local
			escaper: EL_STRING_ESCAPER [ZSTRING]
			str: STRING; zstr: STRING
		do
			create escaper.make (Escape_table.Python_1)
			str := "tab%Tquote'"
			zstr := str
			assert ("correct escape", escaper.escaped (str, False).same_string ("tab\tquote\'"))
			assert_same_string (Void, escaper.escaped (str, True), escaper.escaped (zstr, True))
		end

	test_substitution_marker_unescape
		note
			testing:	"covers/{ZSTRING}.unescape, covers/{ZSTRING}.unescaped",
			 	"covers/{ZSTRING}.make_from_zcode_area, covers/{EL_ZSTRING_UNESCAPER}.unescaped"
		local
			str: ZSTRING
		do
			str := "1 %%S 3"
			str.unescape (Substitution_mark_unescaper)
			assert_same_string ("has substitution marker", str, "1 %S 3")
		end

	test_unescape
		-- TEXT_TEST_SET.test_unescape
		note
			testing:	"covers/{EL_ZSTRING_UNESCAPER}.unescape", "covers/{EL_STRING_32_UNESCAPER}.unescape"
		local
			str, unescaped: ZSTRING; str_32, unescaped_32: STRING_32
			unescaper: EL_ZSTRING_UNESCAPER; unescaper_32: EL_STRING_32_UNESCAPER
			escape_table_32: like new_escape_table
			escape_character: CHARACTER_32
		do
			across << ('\').to_character_32, 'л' >> as l_escape_character loop
				escape_character := l_escape_character.item
				create str_32.make (Text.Russian_and_english.count)
				str_32.append_character (escape_character)
				str_32.append_character (escape_character)

				escape_table_32 := new_escape_table (escape_character)

				across Text.Russian_and_english as character loop
					escape_table_32.search (character.item)
					if escape_table_32.found then
						str_32.append_character (escape_character)
					end
					str_32.append_character (character.item)
				end
				str_32 [str_32.index_of (' ', 1)] := escape_character
				str := str_32

				create unescaper.make (escape_table_32)
				create unescaper_32.make (escape_table_32)

				unescaped := unescaper.unescaped (str)
				unescaped_32 := unescaper_32.unescaped (str_32)
				assert_same_string ("unescape OK", unescaped, unescaped_32)
			end
		end

feature {NONE} -- Implementation

	escape_test (name: STRING; escaper: EL_STRING_ESCAPER [ZSTRING]; escaper_32: EL_STRING_ESCAPER [STRING_32])
		local
			str_32, escaped_32: STRING_32; str, escaped: ZSTRING
			s: EL_STRING_32_ROUTINES
		do
			across << True, False >> as replace_space loop
				across Text.lines as string loop
					str_32 := string.item.twin
					if replace_space.item then
						s.replace_character (str_32, ' ', '/')
					else
						s.replace_character (str_32, '+', '&')
					end
					str := str_32
					escaped := escaper.escaped (str, True)
					escaped_32 := escaper_32.escaped (str_32, True)
					assert_same_string (name + " escape OK", escaped, escaped_32)
				end
			end
		end

	new_escape_table (escape: CHARACTER_32): EL_ESCAPE_TABLE
		do
			create Result.make (escape, {STRING_32} "t:=%T, ь:=в, и:=N")
		end

feature {NONE} -- Constants

	Latin: STRING = "Latin"

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Escape_table.Substitution)
		end

end