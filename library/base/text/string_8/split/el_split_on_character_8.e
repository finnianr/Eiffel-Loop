note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_8} with
		`separator' of type ${CHARACTER_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:35:44 GMT (Wednesday 16th April 2025)"
	revision: "11"

class
	EL_SPLIT_ON_CHARACTER_8 [S -> READABLE_STRING_8]

inherit
	EL_SPLIT_ON_CHARACTER [S, CHARACTER_8]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ON_CHARACTER_8_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make_adjusted (target, separator, adjustments)
		end

	count: INTEGER
		do
			Result := target.occurrences (separator) + 1
		end

end