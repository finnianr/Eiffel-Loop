note
	description: "[
		Table of grouped items defined by `key' function to `make' procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-19 16:47:18 GMT (Friday 19th February 2021)"
	revision: "5"

class
	EL_GROUP_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			make as make_with_count
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