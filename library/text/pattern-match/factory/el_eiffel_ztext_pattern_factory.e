note
	description: "Eiffel text pattern factory for matching text of type [EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 10:18:25 GMT (Saturday 9th January 2021)"
	revision: "6"

class
	EL_EIFFEL_ZTEXT_PATTERN_FACTORY

inherit
	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			unicode as z_code,
			character_to_unicode as character_to_z_code,
			string_argument as zstring_argument
		undefine
			alphanumeric,
			character_to_z_code,
			digit, letter, lowercase_letter,
			non_breaking_white_space_character,
			zstring_argument,
			uppercase_letter,
			white_space_character,
			z_code
		end

	EL_ZTEXT_PATTERN_FACTORY

end