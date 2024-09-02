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
	date: "2024-09-02 8:58:16 GMT (Monday 2nd September 2024)"
	revision: "6"

class
	EL_GROUPED_LIST_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			item as item_list alias "[]",
			extend as extend_list,
			found_item as found_list,
			linear_representation as list_of_lists
		redefine
			make, has_key, search
		end

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create default_found_list.make (0)
			found_list := default_found_list
		end

feature -- Status query

	has_key (key: K): BOOLEAN
			-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		local
			old_position: INTEGER
		do
			old_position := item_position
			internal_search (key)
			Result := found
			if Result then
				found_list := content.item (position)
			else
				found_list := default_found_list
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
				found_list := content.item (position)
			else
				found_list := default_found_list
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
			new_list: like found_list
		do
			if has_key (key) then
				if is_set implies not found_list.has (new) then
					found_list.extend (new)
				end
			else
				create new_list.make (5)
				if object_comparison then
					new_list.compare_objects
				end
				new_list.extend (new)
				extend_list (new_list, key)
			end
		end

feature {NONE} -- Implementation

	is_set: BOOLEAN
		do
		end

feature {NONE} -- Internal attributes

	default_found_list: like found_list

end