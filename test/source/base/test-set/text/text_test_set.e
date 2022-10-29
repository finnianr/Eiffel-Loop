note
	description: "Test string escaping and other text related tests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 8:50:55 GMT (Saturday 29th October 2022)"
	revision: "7"

class
	TEXT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_FORMAT

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		do
			eval.call ("integer_format", agent test_integer_format)
			eval.call ("bash_escape", agent test_bash_escape)
			eval.call ("substitution_marker_unescape", agent test_substitution_marker_unescape)
			eval.call ("unescape", agent test_unescape)
		end

feature -- Tests

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

feature -- Escape tests

	test_bash_escape
		local
			bash_escaper: EL_BASH_PATH_ZSTRING_ESCAPER; bash_escaper_32: EL_BASH_PATH_STRING_32_ESCAPER
		do
			create bash_escaper.make; create bash_escaper_32.make
			escape_test ("BASH", bash_escaper, bash_escaper_32)
		end

feature -- Unescape tests

	test_substitution_marker_unescape
		note
			testing:	"covers/{ZSTRING}.unescape, covers/{ZSTRING}.unescaped",
			 	"covers/{ZSTRING}.make_from_zcode_area, covers/{EL_ZSTRING_UNESCAPER}.unescaped"
		local
			str: ZSTRING
		do
			str := "1 %%S 3"
			str.unescape (Substitution_mark_unescaper)
			assert ("has substitution marker", str.same_string ("1 %S 3"))
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

				escape_table_32 := new_escape_table
				escape_table_32 [escape_character] := escape_character

				across Text.Russian_and_english as character loop
					escape_table_32.search (character.item)
					if escape_table_32.found then
						str_32.append_character (escape_character)
					end
					str_32.append_character (character.item)
				end
				str_32 [str_32.index_of (' ', 1)] := escape_character
				str := str_32

				create unescaper.make (escape_character, escape_table_32)
				create unescaper_32.make (escape_character, escape_table_32)

				unescaped := unescaper.unescaped (str)
				unescaped_32 := unescaper_32.unescaped (str_32)
				assert ("unescape OK", unescaped.same_string (unescaped_32))
			end
		end

feature {NONE} -- Implementation

	escape_test (name: STRING; escaper: EL_ZSTRING_ESCAPER; escaper_32: EL_STRING_32_ESCAPER)
		local
			str_32, escaped_32: STRING_32; str, escaped: ZSTRING
			s: EL_STRING_32_ROUTINES
		do
			across Text.lines as string loop
				str_32 := string.item.twin
				s.replace_character (str_32, '+', '&')
				str := str_32
				escaped := escaper.escaped (str, True)
				escaped_32 := escaper_32.escaped (str_32, True)
				assert (name + " escape OK", escaped.same_string (escaped_32))
			end
		end

	new_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		do
			create Result.make (7)
			Result ['t'] := '%T'
			Result ['ь'] := 'в'
			Result ['и'] := 'N'
 		end

feature {NONE} -- Constants

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make_equal (3)
			table ['S'] := '%S'
			create Result.make ('%%', table)
		end

end