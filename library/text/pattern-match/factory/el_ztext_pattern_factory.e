note
	description: "A [$source EL_TEXT_PATTERN_FACTORY] factory for matching text of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 17:20:36 GMT (Saturday 2nd January 2021)"
	revision: "8"

class
	EL_ZTEXT_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY
		redefine
			alphanumeric,
			character_code_literal, character_literal, character_in_range,
			digit, letter, lowercase_letter,
			non_breaking_white_space_character,
			one_character_from, string_literal, string_literal_caseless, uppercase_letter,
			white_space_character
		end

	EL_SHARED_ZSTRING_CODEC

feature -- Basic patterns

	alphanumeric: EL_ALPHANUMERIC_Z_CHAR_TP
			--
		do
			create Result.make
		end

	character_code_literal (code: NATURAL): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (z_code (code))
		end

	character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (character_to_z_code (literal))
		end

	character_in_range (from_chr, to_chr: CHARACTER): EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (character_to_z_code (from_chr), character_to_z_code (to_chr))
		end

	digit: EL_NUMERIC_Z_CHAR_TP
			--
		do
			create Result.make
		end

	letter: EL_ALPHA_Z_CHAR_TP
			--
		do
			create Result.make
		end

	lowercase_letter: EL_LOWERCASE_ALPHA_Z_CHAR_TP
			--
		do
			create Result.make
		end

	non_breaking_white_space_character: EL_NON_BREAKING_WHITE_SPACE_Z_CHAR_TP
			--
		do
			create Result.make
		end

	one_character_from (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			create Result.make (new_string (a_character_set))
		end

	string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
			--
		do
			create Result.make_from_string (new_string (a_text))
		end

	string_literal_caseless (a_text: READABLE_STRING_GENERAL): EL_CASE_INSENSITIVE_LITERAL_TEXT_PATTERN
		-- case insensitive match of `a_text'
		do
			create Result.make_from_string (new_string (a_text))
		end

	uppercase_letter: EL_UPPERCASE_ALPHA_Z_CHAR_TP
			--
		do
			create Result.make
		end

	white_space_character: EL_WHITE_SPACE_Z_CHAR_TP
			--
		do
			create Result.make
		end

feature {NONE} -- Implementation

	new_string (str: READABLE_STRING_GENERAL): EL_ZSTRING
		do
			if attached {EL_ZSTRING} str as zstr then
				Result := zstr
			else
				create Result.make_from_general (str)
			end
		end

	z_code (code: NATURAL): NATURAL
		do
			Result := Codec.as_z_code (code.to_character_32)
		end

	character_to_z_code (uc: CHARACTER_32): NATURAL
		do
			Result := z_code (uc.natural_32_code)
		end

end