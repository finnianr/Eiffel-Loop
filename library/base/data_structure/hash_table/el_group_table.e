note
	description: "[
		Table of grouped items defined by `key' function to `make' procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-17 17:09:59 GMT (Thursday 17th June 2021)"
	revision: "6"

class
	EL_GROUP_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			found_item as found_list,
			make as make_with_count
		redefine
			make_with_count, has_key, search
		end

create
	make, make_with_count

feature {NONE} -- Initialization

	make (key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `key' function
		local
			l_key: K; group: like item; iterable: EL_ITERABLE_ROUTINES
		do
			make_equal ((iterable.count (a_list) // 2).min (11))
			across a_list as l_list loop
				l_key := key (l_list.item)
				if has_key (l_key) then
					group := found_list
				else
					create group.make (5)
					extend (group, l_key)
				end
				group.extend (l_list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all item (key (l_list.item)).has (l_list.item) end
		end

	make_with_count (n: INTEGER)
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
			-- Search for item of key `key'.
			-- If found, set `found' to true, and set
			-- `found_item' to item associated with `key'.
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

feature {NONE} -- Internal attributes

	default_found_list: like found_list

end