note
	description: "Extends the features of strings conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 15:07:59 GMT (Friday 4th April 2025)"
	revision: "1"

deferred class
	EL_EXTENDED_READABLE_STRING_32

inherit
	EL_EXTENDED_READABLE_STRING_32_I

	EL_EXTENDED_READABLE_STRING [CHARACTER_32]
		rename
			READABLE_X as READABLE_32
		redefine
			target
		end

feature -- Status query

	ends_with (leading: READABLE_STRING_32): BOOLEAN
		do
			Result := target.ends_with (leading)
		end

	has_substring (other: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.has_substring (other)
		end

	starts_with (leading: READABLE_STRING_32): BOOLEAN
		do
			Result := target.starts_with (leading)
		end

feature {NONE} -- Implementation

	target: READABLE_STRING_32
		deferred
		end

end