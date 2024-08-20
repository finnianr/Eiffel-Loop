note
	description: "Implementation of ${EL_SUBSTRING [STRING_GENERAL} for ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:50:56 GMT (Tuesday 20th August 2024)"
	revision: "2"

class
	EL_SUBSTRING_32

inherit
	EL_SUBSTRING [STRING_32]
		rename
			string_x as string_32
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_MODULE_STRING_32

create
	make_empty

convert
	string: {STRING_32}

end