note
	description: "Extends the features of strings conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 10:48:35 GMT (Thursday 17th April 2025)"
	revision: "3"

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

feature -- Measurement

	index_of (c: CHARACTER_32; start_index: INTEGER): INTEGER
		-- Position of first occurrence of `c' at or after `start_index', 0 if none.
		do
			Result := target.index_of (c, start_index)
		end

	last_index_of (c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		-- Position of last occurrence of `c', 0 if none.
		do
			Result := target.last_index_of (c, start_index_from_end)
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