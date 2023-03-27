note
	description: "Arrayed list of key-value pair tuples that can be sorted by key of type `K'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 15:27:31 GMT (Monday 27th March 2023)"
	revision: "9"

class
	EL_KEY_SORTABLE_ARRAYED_MAP_LIST [K -> COMPARABLE, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_sorted, make_from_table

feature {NONE} -- Implementation

	make_sorted (list: FINITE [G]; sort_key: FUNCTION [G, K]; in_ascending_order: BOOLEAN)
		do
			make_from_values (list, sort_key)
			sort (in_ascending_order)
		end

end