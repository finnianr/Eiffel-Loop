note
	description: "Core text patterns for operating on [$source ZSTRING] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 16:28:25 GMT (Monday 31st October 2022)"
	revision: "4"

class
	EL_ZSTRING_PATTERN_FACTORY

inherit
	EL_OPTIMIZED_PATTERN_FACTORY
		redefine
			new_character_literal, new_digit, new_letter, new_white_space_character, new_character_in_set,
			new_string_literal, new_white_space, new_digits_string, new_nonbreaking_white_space,
			new_c_identifier, new_xml_identifier
		end

feature -- Character

	new_c_identifier: EL_MATCH_ZSTRING_C_IDENTIFIER_TP
		do
			create Result.make
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

	new_nonbreaking_white_space (a_minimum_match_count: INTEGER): EL_MATCH_ZSTRING_WHITE_SPACE_TP
		do
			create Result.make_nonbreaking (a_minimum_match_count)
		end

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_ZSTRING_LITERAL_TP
		do
			create Result.make (a_text)
		end

	new_white_space (a_minimum_match_count: INTEGER): EL_MATCH_ZSTRING_WHITE_SPACE_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_ZSTRING_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_xml_identifier: EL_MATCH_ZSTRING_XML_IDENTIFIER_TP
		do
			create Result.make
		end

end