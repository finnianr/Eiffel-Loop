note
	description: "[
		Table defining groups of items from a list of type [$source ECD_ARRAYED_LIST [G]] according to
		the value of some hashable attribute of `G'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-17 17:11:59 GMT (Thursday 17th June 2021)"
	revision: "1"

class
	ECD_GROUP_TABLE [G, K -> detachable HASHABLE]

inherit
	EL_GROUP_TABLE [G, K]
		rename
			make as make_from_list,
			has as has_index
		export
			{NONE} all
			{ECD_ARRAYED_LIST} wipe_out
			{ANY} found, found_list, has_key, generator, search
		end

create
	make

feature {NONE} -- Initialization

	make (a_item_key: like item_key; n: INTEGER)
		do
			item_key := a_item_key
			make_equal (n)
		end

feature {ECD_ARRAYED_LIST} -- Event handlers

	on_delete (a_item: G)
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

	on_extend (a_item: G)
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

	on_replace (old_item, new_item: G)
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
					on_extend (new_item)
				end
			else
				on_delete (old_item)
				on_extend (new_item)
			end
		end

feature {NONE} -- Internal attributes

	item_key: FUNCTION [G, K]
		-- attribute value of type `G' to group by

end