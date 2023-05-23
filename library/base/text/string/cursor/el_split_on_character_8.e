note
	description: "[
		Split `target' string conforming to [$source READABLE_STRING_8] with
		`separator' of type [$source CHARACTER_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-23 10:26:11 GMT (Tuesday 23rd May 2023)"
	revision: "6"

class
	EL_SPLIT_ON_CHARACTER_8 [S -> READABLE_STRING_8]

inherit
	EL_SPLIT_ON_CHARACTER [S]
		redefine
			count, new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ON_CHARACTER_8_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

	count: INTEGER
		do
			Result := target.occurrences (separator.to_character_8) + 1
		end
end