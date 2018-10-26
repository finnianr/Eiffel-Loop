note
	description: "[
		List of all occurrence intervals of a `search_string' in a string conforming to `STRING_GENERAL'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-20 9:30:24 GMT (Saturday 20th October 2018)"
	revision: "5"

class
	EL_OCCURRENCE_INTERVALS [S -> STRING_GENERAL create make end]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_intervals,
			fill as fill_from
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_string: S; search_string: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_default
			fill (a_string, search_string)
		end

	make_default
		do
			make_intervals (5)
		end

feature -- Basic operations

	fill (a_string: S; search_string: READABLE_STRING_GENERAL)
		local
			i, l_count, search_string_count: INTEGER
			search_character: like new_target.item
		do
			wipe_out
			search_character := search_string [1]
			l_count := a_string.count; search_string_count := search_string.count
			from i := 1 until i = 0 or else i > l_count - search_string_count + 1 loop
				if search_string_count = 1 then
					i := a_string.index_of (search_character, i)
				else
					i := a_string.substring_index (search_string, i)
				end
				if i > 0 then
					extend (i, i + search_string_count - 1)
					i := i + search_string_count
				end
			end
		end

feature {NONE} -- Implementation

	new_target: S
		do
			create Result.make (0)
		end
end
