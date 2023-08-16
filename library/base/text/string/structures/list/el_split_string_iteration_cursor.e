note
	description: "Iteration_cursor for [$source EL_SPLIT_READABLE_STRING_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 9:09:34 GMT (Tuesday 8th August 2023)"
	revision: "2"

class
	EL_SPLIT_STRING_ITERATION_CURSOR [S -> STRING_GENERAL create make end]

inherit
	EL_SPLIT_READABLE_STRING_ITERATION_CURSOR [S]
		redefine
			item_copy
		end

create
	make

feature -- Access

	item_copy: S
		local
			i, lower, upper: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				lower := a [i]; upper := a [i + 1]
				create Result.make (upper - lower + 1)
				Result.append_substring (target_string, lower, upper)
			end
		end

end