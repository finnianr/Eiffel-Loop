note
	description: "Iteration_cursor for ${EL_SPLIT_READABLE_STRING_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

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