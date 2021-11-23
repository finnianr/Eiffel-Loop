note
	description: "Implementation of [$source EL_ARRAYED_MAP_LIST] where **K** conforms to [$source HASHABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 13:28:47 GMT (Tuesday 23rd November 2021)"
	revision: "1"

class
	EL_HASHABLE_KEY_ARRAYED_MAP_LIST [K -> HASHABLE, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Factory

	new_grouped_table: EL_HASH_TABLE [EL_ARRAYED_LIST [G], K]
		local
			new_list: EL_ARRAYED_LIST [G]
		do
			push_cursor
			create Result.make_size ((count // 5).max (5))
			from start until after loop
				if Result.has_key (item_key) then
					Result.found_item.extend (item_value)
				else
					create new_list.make (3)
					new_list.extend (item_value)
					Result.extend (new_list, item_key)
				end
				forth
			end
			pop_cursor
		end

end