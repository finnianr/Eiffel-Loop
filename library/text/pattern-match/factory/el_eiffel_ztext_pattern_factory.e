note
	description: "Eiffel text pattern factory for matching text of type [EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 17:42:49 GMT (Saturday 2nd January 2021)"
	revision: "5"

class
	EL_EIFFEL_ZTEXT_PATTERN_FACTORY

inherit
	EL_EIFFEL_TEXT_PATTERN_FACTORY
		undefine
			alphanumeric,
			character_code_literal, character_literal, character_in_range,
			digit, letter, lowercase_letter,
			non_breaking_white_space_character,
			one_character_from, string_literal, string_literal_caseless, uppercase_letter,
			white_space_character
		end

	EL_ZTEXT_PATTERN_FACTORY

end