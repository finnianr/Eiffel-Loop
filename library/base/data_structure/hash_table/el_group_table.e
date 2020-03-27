note
	description: "[
		Table of grouped items defined by `key' function to `make' procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 10:29:53 GMT (Friday 27th March 2020)"
	revision: "4"

class
	EL_GROUP_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			make as make_with_count
		end

	EL_MODULE_ITERABLE

create
	make, make_with_count

feature {NONE} -- Initialization

	make (key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `key' function
		local
			l_key: K
			group: like item
		do
			make_equal ((Iterable.count (a_list) // 2).min (11))
			across a_list as l_list loop
				l_key := key (l_list.item)
				if has_key (l_key) then
					group := found_item
				else
					create group.make (5)
					extend (group, l_key)
				end
				group.extend (l_list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all item (key (l_list.item)).has (l_list.item) end
		end

end
