note
	description: "[
		Table for grouping items into lists according to a hashable key.
		The lists items are implemented as ${EL_ARRAYED_LIST [G]}.
	]"
	notes: "[
		Each item list inherits the object comparison status of the ''Current'' table
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-30 17:56:17 GMT (Thursday 30th January 2025)"
	revision: "15"

class
	EL_GROUPED_LIST_TABLE [G, K -> HASHABLE]

inherit
	EL_HASH_TABLE [SPECIAL [G], K]
		rename
			item_area as item_area_array,
			item as item_area alias "[]",
			item_for_iteration as item_area_for_iteration,
			extend as extend_area,
			found_item as found_area,
			item_list as item_area_list
		redefine
			make, make_equal, has_key, new_cursor, search
		end

	EL_CONTAINER_HANDLER

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create empty_area.make_empty (0)
			create internal_list.make (0)
			found_area := empty_area
		end

	make_equal (n: INTEGER)
		do
			Precursor (n)
			internal_list.compare_objects
		end

feature -- Measurement

	sum_item_count: INTEGER
		do
			Result := sum_integer (agent {SPECIAL [G]}.count)
		end

	item_for_iteration_count: INTEGER
		do
			Result := item_area_for_iteration.count
		end

feature -- Access

	found_list: EL_ARRAYED_LIST [G]
		do
			Result := internal_list
			Result.set_area (found_area)
			Result := Result.twin
		end

	item_for_iteration: EL_ARRAYED_LIST [G]
		do
			Result := internal_list
			Result.set_area (item_area_for_iteration)
			Result := Result.twin
		end

	new_cursor: EL_GROUPED_LIST_TABLE_ITERATION_CURSOR [G, K]
		do
			create Result.make (Current)
			Result.start
		end

feature -- Status query

	has_key (key: K): BOOLEAN
			-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		local
			old_position: INTEGER
		do
			old_position := item_position
			internal_search (key)
			if found then
				found_area := content.item (position)
				Result := True
			else
				found_area := empty_area
			end
			item_position := old_position
		end

feature -- Basic operations

	search (key: K)
			-- Search for group item with key `key'.
			-- If found, set `found' to true, and set
			-- `found_list' to item associated with `key'.
			-- or else set to default list
		local
			old_position: INTEGER
		do
			old_position := item_position
			internal_search (key)
			if found then
				found_area := content.item (position)
			else
				found_area := empty_area
			end
			item_position := old_position
		end

	sort_by_item_count (ascending_order: BOOLEAN)
		-- sort by the number of items in each group
		local
			sorted_table: like Current
		do
			if attached key_list as sorted_keys then
				sorted_keys.order_by (agent group_count, ascending_order)
				if object_comparison then
					create sorted_table.make_equal (count)
				else
					create sorted_table.make (count)
				end
				across sorted_keys as list loop
					sorted_table.extend_area (item_area (list.item), list.item)
				end
				standard_copy (sorted_table)
			end
		end

	wipe_out_lists
		-- wipe out list items
		do
			across item_area_list as list loop
				list.item.wipe_out
			end
		end

feature -- Element change

	extend (key: K; new: G)
		local
			new_area: like found_area
		do
			if has_key (key) and then attached internal_list as list then
				list.set_area (found_area)
				if is_set implies not list.has (new) then
					internal_extend (list, key, new)
				end
			else
				create new_area.make_empty (5)
				new_area.extend (new)
				extend_area (new_area, key)
			end
		end

feature {NONE} -- Implementation

	group_count (a_key: K): INTEGER
		do
			if attached item_area (a_key) as group then
				Result := group.count
			end
		end

	internal_extend (list: like found_list; key: K; new_item: G)
		local
			area: like item_area
		do
			area := list.area
			list.extend (new_item)
			if area /= list.area then
				replace (list.area, key)
			end
		ensure
			replaced_if_bigger: list.area /= old list.area implies replaced
		end

	is_set: BOOLEAN
		do
		end

feature {EL_GROUPED_LIST_TABLE_ITERATION_CURSOR} -- Internal attributes

	empty_area: like found_area

	internal_list: like found_list;

note
	descendants: "[
			EL_GROUPED_LIST_TABLE [G, K -> ${HASHABLE}]
				${EL_GROUPED_SET_TABLE [G, K -> HASHABLE]}
					${EL_FUNCTION_GROUPED_SET_TABLE [G, K -> HASHABLE]}
					${EL_URL_FILTER_TABLE}
				${EL_FUNCTION_GROUPED_LIST_TABLE [G, K -> HASHABLE]}
					${EL_FUNCTION_GROUPED_SET_TABLE [G, K -> HASHABLE]}
	]"
end