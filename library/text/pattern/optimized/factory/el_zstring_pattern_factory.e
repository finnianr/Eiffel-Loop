note
	description: "Core text patterns for operating on [$source ZSTRING] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 10:23:14 GMT (Monday 7th November 2022)"
	revision: "7"

class
	EL_ZSTRING_PATTERN_FACTORY

inherit
	EL_OPTIMIZED_PATTERN_FACTORY
		redefine
			new_character_literal, new_digit, new_letter, new_white_space_character, new_character_in_set,
			new_string_literal, new_white_space, new_digits_string,
			new_c_identifier, new_xml_identifier, new_quoted_c_lang_string
		end

feature -- Character

	new_c_identifier (is_upper: BOOLEAN): EL_MATCH_ZSTRING_C_IDENTIFIER_TP
		do
			if is_upper then
				create Result.make_upper
			else
				create Result.make
			end
		end

	new_character_literal (literal: CHARACTER_32): EL_ZSTRING_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_ZSTRING_CHARACTER_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	new_digit: EL_ZSTRING_NUMERIC_CHAR_TP
			--
		do
			create Result.make
		end

	new_letter: EL_ZSTRING_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

	new_white_space_character: EL_ZSTRING_WHITE_SPACE_CHAR_TP
			--
		do
			create Result.make
		end

feature -- String

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_ZSTRING_LITERAL_TP
		do
			create Result.make (a_text)
		end

	new_white_space (optional, nonbreaking: BOOLEAN): EL_MATCH_ZSTRING_WHITE_SPACE_TP
		do
			create Result.make (optional, nonbreaking)
		end

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_ZSTRING_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_quoted_c_lang_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_ZSTRING_QUOTED_C_LANG_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

	new_xml_identifier: EL_MATCH_ZSTRING_XML_IDENTIFIER_TP
		do
			create Result.make
		end

end