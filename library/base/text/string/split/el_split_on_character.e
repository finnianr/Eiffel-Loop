note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_GENERAL} with
		`separator' of type ${CHARACTER_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:23:01 GMT (Wednesday 16th April 2025)"
	revision: "11"

deferred class
	EL_SPLIT_ON_CHARACTER [RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE]

inherit
	EL_ITERABLE_SPLIT [RSTRING, CHAR, CHAR]

feature -- Access

	new_cursor: EL_SPLIT_ON_CHARACTER_CURSOR [RSTRING, CHAR]
			-- Fresh cursor associated with current structure
		deferred
		end

end