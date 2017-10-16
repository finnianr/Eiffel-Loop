note
	description: "[
		Visit all substrings in a string. `interval' contains indices of each substring.
		`EL_OCCURRENCE_SUBSTRINGS'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_OCCURRENCE_SUBSTRINGS [S -> READABLE_STRING_GENERAL]

inherit
	EL_SUBSTRINGS [S]
		rename
			make as make_substrings,
			fill as chain_fill
		end

create
	make

feature {NONE} -- Initialization

	make (a_string, a_search_string: S)
			--
		do
			make_substrings (a_string, 0)
			fill (a_string, a_search_string)
		end

feature {NONE} -- Implementation

	fill (a_string, search_string: S)
			-- Move to first position if any.
		local
			i, l_count, search_string_count: INTEGER
		do
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