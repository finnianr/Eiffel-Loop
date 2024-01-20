note
	description: "[
		${EL_STRING_BIT_COUNTABLE} applicable to generic class taking a string parameter conforming
		to ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_STRING_32_BIT_COUNTABLE [S -> READABLE_STRING_32]

inherit
	EL_STRING_BIT_COUNTABLE [S]
		undefine
			bit_count
		end

	EL_32_BIT_IMPLEMENTATION

end