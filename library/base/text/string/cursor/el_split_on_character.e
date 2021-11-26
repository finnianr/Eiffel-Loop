note
	description: "[
		Split `target' string conforming to [$source READABLE_STRING_GENERAL] with
		`separator' of type [$source CHARACTER_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 11:22:28 GMT (Friday 26th November 2021)"
	revision: "1"

class
	EL_SPLIT_ON_CHARACTER [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_ITERABLE_SPLIT [S, CHARACTER_32]

create
	make

feature -- Access

	new_cursor: EL_SPLIT_ON_CHARACTER_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted, skip_empty)
		end

end