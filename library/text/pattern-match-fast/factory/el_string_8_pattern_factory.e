note
	description: "Core text patterns for operating on strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:22:59 GMT (Friday 28th October 2022)"
	revision: "1"

class
	EL_STRING_8_PATTERN_FACTORY

inherit
	EL_CORE_PATTERN_FACTORY
		redefine
			new_character_literal, new_digit, new_letter, new_string_literal
		end

feature -- Character

	new_character_literal (literal: CHARACTER_32): EL_STRING_8_LITERAL_CHAR_TP
			--
		do
			create Result.make (literal)
		end

	new_digit: EL_STRING_8_NUMERIC_CHAR_TP
			--
		do
			create Result.make
		end

	new_letter: EL_STRING_8_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

feature -- String

	new_string_literal (a_text: READABLE_STRING_GENERAL): EL_STRING_8_LITERAL_TP
		do
			create Result.make (a_text)
		end
end