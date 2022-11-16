note
	description: "[
		[$source EL_OPTIMIZED_PATTERN_FACTORY] optimized for strings of type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:12:35 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_PATTERN_FACTORY

inherit
	EL_OPTIMIZED_PATTERN_FACTORY
		redefine
			Buffer, copied_substring,
			new_character_literal, new_digit, new_letter, new_white_space_character, new_character_in_set,
			new_string_literal, new_white_space, new_digits_string, new_end_of_line_character,
			new_c_identifier, new_xml_identifier, new_c_quoted_string, new_eiffel_quoted_string,
			new_eiffel_quoted_character, new_alphanumeric, new_quoted_string, new_character_in_range
		end

feature -- Access

	copied_substring (str: ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := Buffer.copied_substring (str, start_index, end_index)
		end

feature -- C language

	new_c_identifier: EL_MATCH_ZSTRING_C_IDENTIFIER_TP
		do
			create Result
		end

	new_c_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_ZSTRING_QUOTED_C_LANG_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

feature -- Eiffel language

	new_eiffel_quoted_character (
		unescaped_action: detachable PROCEDURE [CHARACTER_32]
	): EL_MATCH_ZSTRING_EIFFEL_QUOTED_CHARACTER_TP
		do
			create Result.make (unescaped_action)
		end

	new_eiffel_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_ZSTRING_QUOTED_EIFFEL_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

feature -- XML language

	new_xml_identifier: EL_MATCH_ZSTRING_XML_IDENTIFIER_TP
		do
			create Result
		end

feature -- Character

	new_alphanumeric: EL_ZSTRING_ALPHANUMERIC_CHAR_TP
			--
		do
			create Result
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

	new_character_in_range (lower, upper: CHARACTER): EL_MATCH_ZSTRING_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (lower, upper)
		end

	new_digit: EL_ZSTRING_NUMERIC_CHAR_TP
			--
		do
			create Result
		end

	new_end_of_line_character: EL_ZSTRING_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			create Result.make
		end

	new_letter: EL_ZSTRING_ALPHA_CHAR_TP
			--
		do
			create Result
		end

	new_white_space_character: EL_ZSTRING_WHITE_SPACE_CHAR_TP
			--
		do
			create Result
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

	new_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	): EL_MATCH_ZSTRING_BASIC_QUOTED_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end