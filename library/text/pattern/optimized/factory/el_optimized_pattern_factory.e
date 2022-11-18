note
	description: "[
		Factory for creating new instances of core text-patterns matched against strings
		conforming to [$source READABLE_STRING_GENERAL]
	]"
	notes: "[
		Descendants are optimized to handle [$source ZSTRING] or strings conforming to [$source READABLE_STRING_8]
			
			[$source EL_ZSTRING_PATTERN_FACTORY]
			[$source EL_STRING_8_PATTERN_FACTORY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 17:38:54 GMT (Friday 18th November 2022)"
	revision: "4"

class
	EL_OPTIMIZED_PATTERN_FACTORY

feature -- Access

	copied_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_GENERAL
		do
			Result := Buffer.copied_substring_general (str, start_index, end_index)
		end

feature -- Line ends

	new_end_of_line_character: EL_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			create Result.make
		end

	new_start_of_line: EL_BEGINNING_OF_LINE_TP
			-- Match start of line position
		do
			create Result
		end

feature -- Character

	new_alphanumeric: EL_ALPHANUMERIC_CHAR_TP
			--
		do
			create Result
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_CHARACTER_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	new_character_in_range (lower, upper: CHARACTER): EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (lower, upper)
		end

	new_character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
		end

	new_digit: EL_NUMERIC_CHAR_TP
			--
		do
			create Result
		end

	new_letter: EL_ALPHA_CHAR_TP
			--
		do
			create Result
		end

	new_white_space_character: EL_WHITE_SPACE_CHAR_TP
			--
		do
			create Result
		end

feature -- C language

	new_c_identifier: EL_MATCH_C_IDENTIFIER_TP
		do
			create Result
		end

	new_c_quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): EL_MATCH_QUOTED_CHARACTER_TP
		do
			create {EL_MATCH_C_LANG_QUOTED_CHARACTER_TP} Result.make (unescaped_action)
		end

	new_c_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_QUOTED_STRING_TP
		do
			create {EL_MATCH_QUOTED_C_LANG_STRING_TP} Result.make (quote, unescaped_action)
		end

feature -- Eiffel language

	new_eiffel_quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): EL_MATCH_QUOTED_CHARACTER_TP
		do
			create {EL_MATCH_EIFFEL_QUOTED_CHARACTER_TP} Result.make (unescaped_action)
		end

	new_eiffel_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_QUOTED_STRING_TP
		do
			create {EL_MATCH_QUOTED_EIFFEL_STRING_TP} Result.make (quote, unescaped_action)
		end

feature -- XML language

	new_xml_identifier: EL_MATCH_XML_IDENTIFIER_TP
		do
			create Result
		end

feature -- String

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	): EL_MATCH_BASIC_QUOTED_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
		do
			create Result.make (a_text)
		end

	new_white_space (optional, nonbreaking: BOOLEAN): EL_MATCH_WHITE_SPACE_TP
		do
			create Result.make (optional, nonbreaking)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL]
		once
			create {EL_STRING_32_BUFFER} Result
		end

end