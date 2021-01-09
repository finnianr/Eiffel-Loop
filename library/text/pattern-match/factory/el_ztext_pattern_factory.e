note
	description: "A [$source EL_TEXT_PATTERN_FACTORY] factory for matching text of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 10:20:16 GMT (Saturday 9th January 2021)"
	revision: "9"

class
	EL_ZTEXT_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY
		rename
			unicode as z_code,
			character_to_unicode as character_to_z_code,
			string_argument as zstring_argument
		redefine
			alphanumeric,
			character_to_z_code,
			digit, letter, lowercase_letter,
			non_breaking_white_space_character,
			zstring_argument,
			uppercase_letter,
			white_space_character, z_code
		end

	EL_SHARED_ZSTRING_CODEC

feature -- Basic patterns

	alphanumeric: EL_ALPHANUMERIC_Z_CHAR_TP
			--
		do
			create Result.make
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

	zstring_argument (str: READABLE_STRING_GENERAL): EL_ZSTRING
		do
			create Result.make_from_general (str)
		end

	z_code (code: NATURAL): NATURAL
		do
			Result := Codec.as_z_code (code.to_character_32)
		end

	character_to_z_code (uc: CHARACTER_32): NATURAL
		do
			Result := Codec.as_z_code (uc)
		end

end