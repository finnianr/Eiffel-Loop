note
	description: "[
		Visit all substrings in a string. 'interval' contains indices of each substring.
		EL_OCCURRENCE_SUBSTRINGS
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:24:30 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_OCCURRENCE_SUBSTRINGS

inherit
	EL_SUBSTRINGS
		rename
			make as make_substrings
		end

create
	make

feature {NONE} -- Initialization

	make (a_string, a_search_string: EL_ASTRING)
			--
		do
			make_substrings (a_string)
			search_string := a_search_string
		end

feature -- Access

	interval: INTEGER_INTERVAL

	index: INTEGER

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			index := 0
			after := False
			create interval.make (1, 0)
			forth
		end

	forth
			-- Move to next position
		local
			found_pos: INTEGER
			l_interval: like interval
		do
			l_interval := interval
			found_pos := string.substring_index (search_string, l_interval.upper + 1)
			if found_pos > 0 then
				l_interval.resize_exactly (found_pos, found_pos + search_string.count - 1)
			else
				l_interval.resize_exactly (1, 0)
			end
			after := l_interval.count = 0
			index := index + 1
		ensure then
--			correct_interval: not after implies search_string.is_equal (string.substring (interval.lower, interval.upper))
			correct_interval: not after implies search_string ~ string.substring (interval.lower, interval.upper)
		end

feature -- Status query

	after: BOOLEAN

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := not string.has_substring (search_string)
		end

feature {NONE} -- Implementation

	search_string: EL_ASTRING

	finish
			-- Move to last position.
		do
		end

end