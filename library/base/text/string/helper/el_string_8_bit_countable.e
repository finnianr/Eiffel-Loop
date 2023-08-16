note
	description: "[
		[$source EL_STRING_BIT_COUNTABLE] applicable to generic class taking a string parameter conforming
		to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 6:05:46 GMT (Thursday 27th July 2023)"
	revision: "1"

deferred class
	EL_STRING_8_BIT_COUNTABLE [S -> READABLE_STRING_8]

inherit
	EL_STRING_BIT_COUNTABLE [S]
		undefine
			bit_count
		end

	EL_8_BIT_IMPLEMENTATION

end