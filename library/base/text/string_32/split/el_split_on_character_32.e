note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_32} with
		`separator' of type ${CHARACTER_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:39:51 GMT (Tuesday 20th August 2024)"
	revision: "9"

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