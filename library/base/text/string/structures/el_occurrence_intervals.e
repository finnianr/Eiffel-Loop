note
	description: "[
		List of all occurrence intervals of a `search_string' in a string conforming to `STRING_GENERAL'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 19:19:33 GMT (Monday 27th November 2017)"
	revision: "3"

class
	EL_OCCURRENCE_INTERVALS [S -> STRING_GENERAL create make end]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_intervals
		end

create
	make

feature {NONE} -- Initialization

	make (a_string: S; search_string: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		local
			i, l_count, search_string_count: INTEGER
		do
			make_intervals (5)
			l_count := a_string.count; search_string_count := search_string.count
			from i := 1 until i = 0 or else i > l_count - search_string_count + 1 loop
				if search_string_count = 1 then
					i := a_string.index_of (search_string [1], i)
				else
					i := a_string.substring_index (search_string, i)
				end
				if i > 0 then
					extend (i, i + search_string_count - 1)
					i := i + search_string_count
				end
			end
		end

end