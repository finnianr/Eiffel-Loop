note
	description: "Test string escaping and other text related tests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 16:20:16 GMT (Thursday 5th January 2023)"
	revision: "14"

class
	TEXT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING; EL_MODULE_FORMAT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_TEST_TEXT

	EL_SHARED_ESCAPE_TABLE

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		do
			eval.call ("bash_escape", agent test_bash_escape)
			eval.call ("convert_string_to_makeable", agent test_convert_string_to_makeable)
			eval.call ("convert_string_type_descriptions", agent test_convert_string_type_descriptions)
			eval.call ("integer_format", agent test_integer_format)
			eval.call ("substitution_marker_unescape", agent test_substitution_marker_unescape)
			eval.call ("python_escape", agent test_python_escape)
			eval.call ("unescape", agent test_unescape)
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
		note
			testing: "covers/{EL_READABLE_STRING_GENERAL_TO_TYPE}.new_type_description"
		do
			if attached crc_generator as crc then
				output_type_descriptions (crc)
				lio.put_natural_field ("Checksum", crc.checksum)
				lio.put_new_line
				if crc.checksum = 176473444 then
					assert ("Expected descriptions", True)
				else
					output_type_descriptions (Void)
				end
			end
		end

	test_integer_format
		local
			padding, formatted: STRING; width: INTEGER
			zero_padded: BOOLEAN; padding_character: CHARACTER
		do
			across << True, False >> as bool loop
				zero_padded := bool.item
				across 1 |..| 10 as n loop
					width := n.item
					if zero_padded then
						padding_character := '0'
						formatted := Format.integer_zero (1, width)
					else
						padding_character := ' '
						formatted := Format.integer (1, width)
					end
					create padding.make_filled (padding_character, width - 1)
					assert ("same string", formatted ~ padding + "1")
				end
			end
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
 			Result [escape] := escape
		end

	output_type_descriptions (crc_check: detachable EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across Convert_string.type_list as list loop
				if attached Convert_string.type_descripton (list.item) as description then
					if attached crc_check as crc then
						crc.add_string_8 (description)
					else
						lio.put_line (description)
					end
				end
			end
		end
feature {NONE} -- Constants

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Escape_table.Substitution)
		end

end