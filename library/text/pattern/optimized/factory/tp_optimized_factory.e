note
	description: "[
		Factory for creating new instances of core text-patterns matched against strings
		conforming to ${READABLE_STRING_GENERAL}
	]"
	notes: "[
		Descendants are optimized to handle ${ZSTRING} or strings conforming to ${READABLE_STRING_8}
			
			${TP_ZSTRING_OPTIMIZED_FACTORY}
			${TP_RSTRING_OPTIMIZED_FACTORY}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 13:27:45 GMT (Thursday 9th November 2023)"
	revision: "9"

class
	TP_OPTIMIZED_FACTORY

feature -- Access

	copied_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_GENERAL
		do
			Result := Buffer.copied_substring_general (str, start_index, end_index)
		end

feature -- Line ends

	new_end_of_line_character: TP_END_OF_LINE_CHAR
			-- Matches new line or EOF
		do
			create Result
		end

	new_start_of_line: TP_BEGINNING_OF_LINE
			-- Match start of line position
		do
			create Result
		end

feature -- Character

	new_alphanumeric: TP_ALPHANUMERIC_CHAR
			--
		do
			create Result
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): TP_CHARACTER_IN_SET
			--
		do
			create Result.make (a_character_set)
		end

	new_character_in_range (lower, upper: CHARACTER): TP_CHAR_IN_ASCII_RANGE
			--
		do
			create Result.make (lower, upper)
		end

	new_character_literal (literal: CHARACTER_32): TP_LITERAL_CHAR
			--
		do
			create Result.make (literal)
		end

	new_digit: TP_NUMERIC_CHAR
			--
		do
			create Result
		end

	new_letter: TP_ALPHA_CHAR
			--
		do
			create Result
		end

	new_white_space_character: TP_WHITE_SPACE_CHAR
			--
		do
			create Result
		end

feature -- C language

	new_c_identifier: TP_C_IDENTIFIER
		do
			create Result
		end

	new_c_quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): TP_QUOTED_CHAR
		do
			create {TP_C_LANG_QUOTED_CHAR} Result.make (unescaped_action)
		end

	new_c_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): TP_QUOTED_STRING
		do
			create {TP_QUOTED_C_LANG_STRING} Result.make (quote, unescaped_action)
		end

feature -- Eiffel language

	new_eiffel_quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): TP_QUOTED_CHAR
		do
			create {TP_EIFFEL_QUOTED_CHAR} Result.make (unescaped_action)
		end

	new_eiffel_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): TP_QUOTED_STRING
		do
			create {TP_QUOTED_EIFFEL_STRING} Result.make (quote, unescaped_action)
		end

feature -- XML language

	new_xml_identifier: TP_XML_IDENTIFIER
		do
			create Result
		end

feature -- String

	new_digits_string (a_minimum_match_count: INTEGER): TP_DIGITS
		do
			create Result.make (a_minimum_match_count)
		end

	new_hexadecimal_string (a_minimum_match_count: INTEGER): TP_HEXADECIMAL_DIGITS
			--
		do
			create Result.make (a_minimum_match_count)
		end

	new_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	): TP_BASIC_QUOTED_STRING
		do
			create Result.make (quote, unescaped_action)
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): TP_LITERAL_PATTERN
		do
			create Result.make (a_text)
		end

	new_white_space (optional, nonbreaking: BOOLEAN): TP_WHITE_SPACE
		do
			create Result.make (optional, nonbreaking)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL]
		once
			create {EL_STRING_32_BUFFER} Result
		end

end


















