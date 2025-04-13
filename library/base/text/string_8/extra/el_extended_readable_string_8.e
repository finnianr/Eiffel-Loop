note
	description: "Extends the features of strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 17:49:28 GMT (Sunday 13th April 2025)"
	revision: "3"

deferred class
	EL_EXTENDED_READABLE_STRING_8

inherit
	EL_EXTENDED_READABLE_STRING_8_I

	EL_EXTENDED_READABLE_STRING [CHARACTER_8]
		rename
			READABLE_X as READABLE_8
		undefine
			convertible_to_char
		redefine
			target
		end

feature -- Status query

	ends_with (leading: READABLE_STRING_8): BOOLEAN
		do
			Result := target.ends_with (leading)
		end

	has_substring (other: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.has_substring (other)
		end

	starts_with (leading: READABLE_STRING_8): BOOLEAN
		do
			Result := target.starts_with (leading)
		end

feature {NONE} -- Implementation

	target: READABLE_STRING_8
		deferred
		end

end