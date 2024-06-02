note
	description: "[
		Table for grouping items of type `G' into lists of type ${EL_ARRAYED_LIST [G]} according to
		the result of applying a function agent of type ${FUNCTION [G, K]} where **K** conforms to
		${HASHABLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-02 11:39:38 GMT (Sunday 2nd June 2024)"
	revision: "13"

class
	EL_FUNCTION_GROUP_TABLE [G, K -> HASHABLE]

inherit
	EL_GROUP_TABLE [G, K]
		rename
			make as make_with_count
		end

	EL_MODULE_ITERABLE

create
	make, make_from_list

feature {NONE} -- Initialization

	make (a_item_key: like item_key; n: INTEGER)
		do
			item_key := a_item_key
			make_with_count (n)
		end

	make_from_list (a_item_key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `a_item_key' function
		do
			make (a_item_key, (Iterable.count (a_list) // 2).min (11))
			across a_list as list loop
				extend (a_item_key (list.item), list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all
				item_list (a_item_key (l_list.item)).has (l_list.item)
			end
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
				extend_list (found_list, key)
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

	item_key: FUNCTION [G, K]
		-- attribute value of type `G' to group by

end