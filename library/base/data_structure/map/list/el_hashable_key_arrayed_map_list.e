note
	description: "Implementation of ${EL_ARRAYED_MAP_LIST} where **K** conforms to ${HASHABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

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