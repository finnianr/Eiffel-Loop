note
	description: "Implementation of ${EL_ARRAYED_MAP_LIST} where **K** conforms to ${HASHABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 10:39:33 GMT (Tuesday 3rd September 2024)"
	revision: "6"

class
	EL_HASHABLE_KEY_ARRAYED_MAP_LIST [K -> HASHABLE, G]

obsolete
	"Use {EL_ARRAYED_MAP_LIST}.to_grouped_list_table"

inherit
	EL_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Conversion

	new_grouped_list_table: EL_GROUPED_LIST_TABLE [G, K]
		do
			push_cursor
			create Result.make_equal ((count // 5).max (5))
			from start until after loop
				Result.extend (item_key, item_value)
				forth
			end
			pop_cursor
		end

	new_grouped_set_table: EL_GROUPED_SET_TABLE [G, K]
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
