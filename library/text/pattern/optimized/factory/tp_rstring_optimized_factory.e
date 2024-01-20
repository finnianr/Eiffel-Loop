note
	description: "[
		${TP_OPTIMIZED_FACTORY} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	TP_RSTRING_OPTIMIZED_FACTORY

inherit
	TP_OPTIMIZED_FACTORY
		redefine
			Buffer, copied_substring,
			new_character_literal, new_digit, new_letter, new_white_space_character, new_character_in_set,
			new_string_literal, new_white_space, new_digits_string, new_end_of_line_character,
			new_c_identifier, new_xml_identifier, new_c_quoted_string, new_eiffel_quoted_string,
			new_eiffel_quoted_character, new_alphanumeric, new_quoted_string, new_character_in_range,
			new_start_of_line, new_c_quoted_character, new_hexadecimal_string
		end

feature -- Access

	copied_substring (str: READABLE_STRING_8; start_index, end_index: INTEGER): STRING
		do
			Result := Buffer.copied_substring (str, start_index, end_index)
		end

feature -- Line ends

	new_end_of_line_character: TP_RSTRING_END_OF_LINE_CHAR
			-- Matches new line or EOF
		do
			create Result
		end

	new_start_of_line: TP_RSTRING_BEGINNING_OF_LINE
			-- Match start of line position
		do
			create Result
		end

feature -- C language

	new_alphanumeric: TP_RSTRING_ALPHANUMERIC_CHAR
			--
		do
			create Result
		end

	new_c_identifier: TP_RSTRING_C_IDENTIFIER
		do
			create Result
		end

	new_c_quoted_character (
		unescaped_action: detachable PROCEDURE [CHARACTER_32]
	): TP_RSTRING_C_LANG_QUOTED_CHAR
		do
			create Result.make (unescaped_action)
		end

	new_c_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): TP_RSTRING_QUOTED_C_LANG_STRING
		do
			create Result.make (quote, unescaped_action)
		end

feature -- Eiffel language

	new_eiffel_quoted_character (
		unescaped_action: detachable PROCEDURE [CHARACTER_32]
	): TP_RSTRING_EIFFEL_QUOTED_CHAR
		do
			create Result.make (unescaped_action)
		end

	new_eiffel_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): TP_RSTRING_QUOTED_EIFFEL_STRING
		do
			create Result.make (quote, unescaped_action)
		end

feature -- XML language

	new_xml_identifier: TP_RSTRING_XML_IDENTIFIER
		do
			create Result
		end

feature -- Character

	new_character_literal (literal: CHARACTER_32): TP_RSTRING_LITERAL_CHAR
			--
		do
			create Result.make (literal)
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): TP_RSTRING_CHARACTER_IN_SET
			--
		do
			create Result.make (a_character_set)
		end

	new_character_in_range (lower, upper: CHARACTER): TP_RSTRING_CHAR_IN_ASCII_RANGE
			--
		do
			create Result.make (lower, upper)
		end

	new_digit: TP_RSTRING_NUMERIC_CHAR
			--
		do
			create Result
		end

	new_letter: TP_RSTRING_ALPHA_CHAR
			--
		do
			create Result
		end

	new_white_space_character: TP_RSTRING_WHITE_SPACE_CHAR
			--
		do
			create Result
		end

feature -- String

	new_digits_string (a_minimum_match_count: INTEGER): TP_RSTRING_DIGITS
		do
			create Result.make (a_minimum_match_count)
		end

	new_hexadecimal_string (a_minimum_match_count: INTEGER): TP_RSTRING_HEXADECIMAL_DIGITS
			--
		do
			create Result.make (a_minimum_match_count)
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): TP_RSTRING_LITERAL
		do
			create Result.make (a_text)
		end

	new_white_space (optional, nonbreaking: BOOLEAN): TP_RSTRING_WHITE_SPACE
		do
			create Result.make (optional, nonbreaking)
		end

	new_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	): TP_RSTRING_BASIC_QUOTED_STRING
		do
			create Result.make (quote, unescaped_action)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end














