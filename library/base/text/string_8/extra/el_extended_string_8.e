note
	description: "${EL_EXTENDED_STRING_GENERAL} implemented for ${CHARACTER_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 17:59:24 GMT (Friday 11th April 2025)"
	revision: "3"

deferred class
	EL_EXTENDED_STRING_8

inherit
	EL_EXTENDED_STRING_GENERAL [CHARACTER_8]
		rename
			empty_target as empty_string_8,
			READABLE_X AS READABLE_8
		undefine
			latin_1_count
		redefine
			shared_string
		end

	EL_EXTENDED_READABLE_STRING_8_I
		rename
			empty_target as empty_string_8,
			target as shared_string
		end

	EL_STRING_BIT_COUNTABLE [STRING_8]

feature {NONE} -- Implementation

	shared_string: READABLE_STRING_8
		deferred
		end

end