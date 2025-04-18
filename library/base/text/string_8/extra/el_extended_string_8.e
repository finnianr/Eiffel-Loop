note
	description: "${EL_EXTENDED_STRING_GENERAL} implemented for ${CHARACTER_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 14:31:03 GMT (Saturday 19th April 2025)"
	revision: "5"

deferred class
	EL_EXTENDED_STRING_8

inherit
	EL_EXTENDED_STRING_GENERAL [CHARACTER_8]
		rename
			READABLE_X AS READABLE_8
		undefine
			convertible_to_char
		redefine
			shared_string
		end

	EL_EXTENDED_READABLE_STRING_8_I
		rename
			target as shared_string
		end

	EL_STRING_BIT_COUNTABLE [STRING_8]

feature {NONE} -- Implementation

	shared_string: READABLE_STRING_8
		deferred
		end

end