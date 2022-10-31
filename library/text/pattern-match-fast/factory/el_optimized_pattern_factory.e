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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 16:50:10 GMT (Monday 31st October 2022)"
	revision: "4"

class
	EL_OPTIMIZED_PATTERN_FACTORY

feature -- Character

	new_character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
		end

	new_character_in_set (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_CHARACTER_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	new_digit: EL_NUMERIC_CHAR_TP
			--
		do
			create Result.make
		end

	new_letter: EL_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

	new_white_space_character: EL_WHITE_SPACE_CHAR_TP
			--
		do
			create Result.make
		end

feature -- String

	new_c_identifier: EL_MATCH_C_IDENTIFIER_TP
		do
			create Result.make
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
		do
			create Result.make (a_text)
		end

	new_white_space (a_minimum_match_count: INTEGER): EL_MATCH_WHITE_SPACE_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_nonbreaking_white_space (a_minimum_match_count: INTEGER): EL_MATCH_WHITE_SPACE_TP
		do
			create Result.make_nonbreaking (a_minimum_match_count)
		end

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_quoted_c_lang_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [READABLE_STRING_GENERAL]
	): EL_MATCH_QUOTED_C_LANG_STRING_TP
		do
			create Result.make (quote, unescaped_action)
		end

	new_xml_identifier: EL_MATCH_XML_IDENTIFIER_TP
		do
			create Result.make
		end

end