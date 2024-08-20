note
	description: "Implementation of ${EL_SUBSTRING [STRING_GENERAL} for ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:58:52 GMT (Tuesday 20th August 2024)"
	revision: "2"

class
	EL_ZSUBSTRING

inherit
	EL_SUBSTRING [ZSTRING]
		rename
			string_x as string_z
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_MODULE_STRING
		rename
			string as string_z
		end

create
	make_empty

convert
	string: {ZSTRING}

end