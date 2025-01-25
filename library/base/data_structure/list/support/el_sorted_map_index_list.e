note
	description: "[
		Extended ${EL_SORTED_INDEX_LIST} to sort ${EL_ARRAYED_MAP_LIST} containers by both key and value
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-25 16:35:41 GMT (Saturday 25th January 2025)"
	revision: "1"

class
	EL_SORTED_MAP_INDEX_LIST

inherit
	EL_SORTED_INDEX_LIST
		rename
			make as make_sorted
		redefine
			less_than
		end

create
	make

feature {NONE} -- Initialization

	make (a_target, a_group_items: SPECIAL [COMPARABLE]; in_ascending_order, ascending_group: BOOLEAN)
		require
			same_size_arrays: a_target.count = a_group_items.count
		local
			i, last_index, lower_i, upper_i, max_group_count, item_count: INTEGER
			group_intervals: EL_ARRAYED_INTERVAL_LIST; group_item: COMPARABLE
			group_index_area: SPECIAL [INTEGER]
		do
			group_items := a_group_items
			make_sorted (a_target, in_ascending_order)
			if in_ascending_order /= ascending_group and count > 1 then
			-- reverse indexed order of each group
				create group_intervals.make ((count // 10).max (10))
				if attached area as index_area and then attached target as t then
					lower_i := 0; upper_i := 0; group_item := t [lower_i]
					last_index := count - 1
					group_item := t [index_area [0]]
					from i := 1 until i > last_index loop
						if group_item ~ t [index_area [i]] then
							upper_i := i
						else
							group_intervals.extend (lower_i, upper_i)
							lower_i := i; upper_i := i
							group_item := t [index_area [i]]
						end
						i := i + 1
					end
					group_intervals.extend (lower_i, last_index)
					if attached group_intervals as list then
						from list.start until list.after loop
							if list.item_count > max_group_count then
								max_group_count := list.item_count
							end
							list.forth
						end
						create group_index_area.make_empty (max_group_count)
						from list.start until list.after loop
							group_index_area.wipe_out
							lower_i := list.item_lower; upper_i := list.item_upper
							item_count := upper_i - lower_i + 1
							if item_count > 1 then
								from i := upper_i until i < lower_i loop
									group_index_area.extend (index_area [i])
									i := i - 1
								end
								index_area.copy_data (group_index_area, 0, lower_i, item_count)
							end
							list.forth
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	less_than (i_1, i_2: INTEGER): BOOLEAN
		do
			if attached target as t then
				if t [i_1] ~ t [i_2] then
					if attached group_items as g then
						Result := g [i_1] < g [i_2]
					end
				else
					Result := t [i_1] < t [i_2]
				end
			end
		end

feature {NONE} -- Internal attributes

	group_items: SPECIAL [COMPARABLE]
end