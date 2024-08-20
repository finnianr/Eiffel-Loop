note
	description: "Implementation of ${EL_SUBSTRING [STRING_GENERAL} for ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:58:30 GMT (Tuesday 20th August 2024)"
	revision: "3"

class
	EL_SUBSTRING_8

inherit
	EL_SUBSTRING [STRING_8]
		rename
			string_x as string_8
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_MODULE_STRING_8

create
	make_empty

convert
	string: {STRING_8}

end