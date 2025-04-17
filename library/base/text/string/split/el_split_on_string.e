note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_GENERAL} with
		`separator' of type ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:25:34 GMT (Wednesday 16th April 2025)"
	revision: "10"

deferred class
	EL_SPLIT_ON_STRING [RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE]

inherit
	EL_ITERABLE_SPLIT [RSTRING, CHAR, READABLE_STRING_GENERAL]

feature -- Access

	new_cursor: EL_SPLIT_ON_STRING_CURSOR [RSTRING, CHAR]
			-- Fresh cursor associated with current structure
		deferred
		end

feature -- Measurement

	count: INTEGER
		do
			across Current as item loop
				Result := Result + 1
			end
		end
end