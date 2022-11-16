note
	description: "Implementation of [$source EL_ARRAYED_MAP_LIST] where **K** conforms to [$source HASHABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_HASHABLE_KEY_ARRAYED_MAP_LIST [K -> HASHABLE, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Factory

	new_grouped_table: EL_GROUP_TABLE [G, K]
		do
			push_cursor
			create Result.make_equal ((count // 5).max (5))
			from start until after loop
				Result.extend (item_key, item_value)
				forth
			end
			pop_cursor
		end

end