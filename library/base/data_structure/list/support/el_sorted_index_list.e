note
	description: "List of sorted indices for ${SPECIAL [COMPARABLE]} array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_SORTED_INDEX_LIST

inherit
	ARRAYED_LIST [INTEGER]
		rename
			make as make_list
		end

	PART_COMPARATOR [INTEGER]
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_target: SPECIAL [COMPARABLE]; in_ascending_order: BOOLEAN)
		local
			i: INTEGER
		do
			target := a_target
			make_list (a_target.count)
			if attached area as a then
				from i := 0 until i = a_target.count loop
					a.extend (i)
					i := i + 1
				end
			end
			if in_ascending_order then
				sorter.sort (Current)
			else
				sorter.reverse_sort (Current)
			end
		end

feature {NONE} -- Implementation

	sorter: SORTER [like item]
		do
			if count < 50 then
				create {BUBBLE_SORTER [INTEGER]} Result.make (Current)
			else
				create {QUICK_SORTER [INTEGER]} Result.make (Current)
			end
		end

feature {NONE} -- Implementation

	less_than (i_1, i_2: INTEGER): BOOLEAN
		do
			if attached target as t then
				Result := t [i_1] < t [i_2]
			end
		end

feature {NONE} -- Internal attributes

	target: SPECIAL [COMPARABLE]
end