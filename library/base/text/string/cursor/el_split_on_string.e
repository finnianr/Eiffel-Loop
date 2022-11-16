note
	description: "[
		Split `target' string conforming to [$source READABLE_STRING_GENERAL] with
		`separator' of type [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_SPLIT_ON_STRING [S -> READABLE_STRING_GENERAL]

inherit
	EL_ITERABLE_SPLIT [S, READABLE_STRING_GENERAL]

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ON_STRING_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end