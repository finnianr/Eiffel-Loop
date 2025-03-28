note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_32} with
		`separator' of type ${CHARACTER_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 11:42:11 GMT (Saturday 15th March 2025)"
	revision: "10"

class
	EL_SPLIT_ON_CHARACTER_32 [S -> READABLE_STRING_32]

inherit
	EL_SPLIT_ON_CHARACTER [S]
		redefine
			count, new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ON_CHARACTER_32_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

	count: INTEGER
		do
			Result := target.occurrences (separator) + 1
		end
end