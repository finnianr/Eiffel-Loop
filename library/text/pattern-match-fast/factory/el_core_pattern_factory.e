note
	description: "[
		Factory for creating new instances of core patterns matched against strings
		conforming to [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 16:05:59 GMT (Saturday 29th October 2022)"
	revision: "2"

class
	EL_CORE_PATTERN_FACTORY

feature -- Character

	new_character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
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

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
		do
			create Result.make (a_text)
		end

	new_white_space (a_minimum_match_count: INTEGER): EL_MATCH_WHITE_SPACE_TP
		do
			create Result.make (a_minimum_match_count)
		end

	new_digits_string (a_minimum_match_count: INTEGER): EL_MATCH_DIGITS_TP
		do
			create Result.make (a_minimum_match_count)
		end

end

