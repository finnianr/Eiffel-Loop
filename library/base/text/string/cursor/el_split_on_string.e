note
	description: "[
		Split `target' string conforming to [$source READABLE_STRING_GENERAL] with
		`separator' of type [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-28 12:30:36 GMT (Sunday 28th November 2021)"
	revision: "2"

class
	EL_SPLIT_ON_STRING [S -> READABLE_STRING_GENERAL]

inherit
	EL_ITERABLE_SPLIT [S, READABLE_STRING_GENERAL]

create
	make

feature -- Access

	new_cursor: EL_SPLIT_ON_STRING_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end