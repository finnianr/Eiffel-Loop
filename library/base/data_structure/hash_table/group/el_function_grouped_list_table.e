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
	date: "2024-09-20 10:33:20 GMT (Friday 20th September 2024)"
	revision: "16"

class
	EL_FUNCTION_GROUPED_LIST_TABLE [G, K -> HASHABLE]

inherit
	EL_GROUPED_LIST_TABLE [G, K]
		rename
			make as make_with_count
		end

	EL_MODULE_ITERABLE

create
	make, make_from_list

feature {NONE} -- Initialization

	make (a_group_key: like group_key; n: INTEGER)
		do
			group_key := a_group_key
			make_with_count (n)
		end

	make_from_list (a_group_key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `a_group_key' function
		do
			make (a_group_key, (Iterable.count (a_list) // 2).min (11))
			across a_list as list loop
				extend (a_group_key (list.item), list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all
				item_list (a_group_key (l_list.item)).has (l_list.item)
			end
		end

feature -- Element change

	list_extend (new: G)
		-- extend group list with key `group_key (a_item)'
		do
			extend (group_key (new), new)
		end

	list_replace (old_item, new_item: G)
		-- replace `old_item' with `new_item' in group list with key `group_key (a_item)'
		local
			old_key, new_key: K
		do
			old_key := group_key (old_item)
			new_key := group_key (new_item)
			if old_key ~ new_key then
				if has_key (old_key) and then attached internal_list as list then
					list.set_area (found_area)
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
		-- prune `a_item' from group list with key `group_key (a_item)'
		-- and if the list is empty, remove the `item_list' entirely
		local
			key: K
		do
			key := group_key (a_item)
			if has_key (key) and then attached found_list as list then
				list.start
				list.prune (a_item)
				if list.is_empty then
					remove (key)
				end
			end
		end

feature {NONE} -- Implementation

	item_list (key: K): like found_list
		do
			if attached item_area (key) as area then
				Result := internal_list
				Result.set_area (area)
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Internal attributes

	group_key: FUNCTION [G, K]
		-- attribute value of type `G' to group by

end