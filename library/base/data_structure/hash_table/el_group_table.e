note
	description: "[
		Table splitting items of type `G' into groups of type [$source EL_ARRAYED_LIST [G]] according to
		the applied value of a function agent of type [$source FUNCTION [G, K]].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-19 8:28:15 GMT (Saturday 19th June 2021)"
	revision: "7"

class
	EL_GROUP_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			item as item_list,
			found_item as found_list,
			make as make_with_count
		redefine
			make_with_count, has_key, search
		end

create
	make, make_from_list, make_with_count

feature {NONE} -- Initialization

	make (a_item_key: like item_key; n: INTEGER)
		do
			item_key := a_item_key
			make_equal (n)
		end

	make_from_list (a_item_key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `a_item_key' function
		local
			l_key: K; group: like item_list; iterable: EL_ITERABLE_ROUTINES
		do
			make (a_item_key, (iterable.count (a_list) // 2).min (11))
			across a_list as l_list loop
				l_key := a_item_key (l_list.item)
				if has_key (l_key) then
					group := found_list
				else
					create group.make (5)
					extend (group, l_key)
				end
				group.extend (l_list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all
				item_list (a_item_key (l_list.item)).has (l_list.item)
			end
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

feature -- Element change

	list_extend (a_item: G)
		-- extend group list with key `item_key (a_item)'
		local
			key: K
		do
			key := item_key (a_item)
			if has_key (key) then
				found_list.extend (a_item)
			else
				create found_list.make_empty
				found_list.extend (a_item)
				extend (found_list, key)
			end
		end

	list_replace (old_item, new_item: G)
		-- replace `old_item' with `new_item' in group list with key `item_key (a_item)'
		local
			old_key, new_key: K
		do
			old_key := item_key (old_item)
			new_key := item_key (new_item)
			if old_key ~ new_key then
				if has_key (old_key) and then attached found_list as list then
					list.start
					list.search (old_item)
					if list.exhausted then
						list.extend (new_item)
					else
						list.replace (new_item)
					end
				else
					list_extend (new_item)
				end
			else
				list_delete (old_item)
				list_extend (new_item)
			end
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

feature -- Removal

	list_delete (a_item: G)
		-- prune `a_item' from group list with key `item_key (a_item)'
		-- and if the list is empty, remove the `item_list' entirely
		local
			key: K
		do
			key := item_key (a_item)
			if has_key (key) and then attached found_list as list then
				list.start
				list.prune (a_item)
				if list.is_empty then
					remove (key)
				end
			end
		end

feature {NONE} -- Internal attributes

	default_found_list: like found_list

	item_key: FUNCTION [G, K]
		-- attribute value of type `G' to group by

end