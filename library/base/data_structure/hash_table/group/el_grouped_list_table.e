note
	description: "[
		Table for grouping items into lists according to a hashable key.
		The lists items are implemented as ${EL_ARRAYED_LIST [G]}.
	]"
	notes: "[
		Each item list inherits the object comparison status of the ''Current'' table
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-05 16:20:28 GMT (Thursday 5th September 2024)"
	revision: "7"

class
	EL_GROUPED_LIST_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [SPECIAL [G], K]
		rename
			item as item_area alias "[]",
			extend as extend_area,
			found_item as found_area,
			linear_representation as list_of_lists
		redefine
			make, make_equal, has_key, search
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

feature -- Access

	found_list: EL_ARRAYED_LIST [G]
		do
			internal_list.set_area (found_area)
			Result := internal_list.twin
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
			if not found then
				found_area := empty_area
			end
			item_position := old_position
		end

	wipe_out_lists
		-- wipe out list items
		do
			across list_of_lists as list loop
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

	internal_extend (list: like found_list; key: K; new_item: G)
		local
			old_capacity: INTEGER
		do
			old_capacity := list.capacity
			list.extend (new_item)
			if old_capacity /= list.capacity then
				replace (list.area, key)
			end
		end

	is_set: BOOLEAN
		do
		end

feature {NONE} -- Internal attributes

	empty_area: like found_area

	internal_list: like found_list

end