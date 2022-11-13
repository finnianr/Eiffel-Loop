note
	description: "Core text patterns for operating on strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-12 12:26:02 GMT (Saturday 12th November 2022)"
	revision: "9"

class
	EL_STRING_8_PATTERN_FACTORY

inherit
	EL_OPTIMIZED_PATTERN_FACTORY
		redefine
			new_character_literal, new_digit, new_letter, new_white_space_character, new_character_in_set,
			new_string_literal, new_white_space, new_digits_string, new_end_of_line_character,
			new_c_identifier, new_xml_identifier, new_quoted_c_lang_string, new_quoted_eiffel_string
		end

feature -- Character

	new_character_literal (literal: CHARACTER_32): EL_STRING_8_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_STRING_8_CHARACTER_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	new_digit: EL_STRING_8_NUMERIC_CHAR_TP
			--
		do
			create Result
		end

	new_end_of_line_character: EL_STRING_8_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			create Result.make
		end

	new_letter: EL_STRING_8_ALPHA_CHAR_TP
			--
		do
			create Result
		end

	new_white_space_character: EL_STRING_8_WHITE_SPACE_CHAR_TP
			--
		do
			create Result
		end

feature -- String

	new_c_identifier: EL_MATCH_STRING_8_C_IDENTIFIER_TP
		do
			create Result
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_STRING_8_LITERAL_TP
		do
			create Result.make (a_text)
		end

	new_white_space (optional, nonbreaking: BOOLEAN): EL_MATCH_STRING_8_WHITE_SPACE_TP
		do
			create Result.make (optional, nonbreaking)
		end

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_STRING_8_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_quoted_c_lang_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_STRING_8_QUOTED_C_LANG_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

	new_quoted_eiffel_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_STRING_8_QUOTED_EIFFEL_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

	new_xml_identifier: EL_MATCH_STRING_8_XML_IDENTIFIER_TP
		do
			create Result
		end

end