note
	description: "${EL_EXTENDED_STRING_GENERAL} implemented for ${CHARACTER_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 17:59:32 GMT (Friday 11th April 2025)"
	revision: "3"

deferred class
	EL_EXTENDED_STRING_32

inherit
	EL_EXTENDED_STRING_GENERAL [CHARACTER_32]
		rename
			READABLE_X AS READABLE_32
		redefine
			shared_string
		end

	EL_EXTENDED_READABLE_STRING_32_I
		rename
			target as shared_string
		end

	EL_STRING_BIT_COUNTABLE [STRING_32]

feature {NONE} -- Implementation

	shared_string: READABLE_STRING_32
		deferred
		end

end