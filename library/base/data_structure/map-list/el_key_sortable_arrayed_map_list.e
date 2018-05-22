note
	description: "Arrayed list of key-value pair tuples that can be sorted by key of type `K'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 8:19:32 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_KEY_SORTABLE_ARRAYED_MAP_LIST [K -> {HASHABLE, COMPARABLE}, G]

inherit
	EL_SORTABLE_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table, make_sorted

feature {NONE} -- Implementation

	make_sorted (list: FINITE [G]; sort_key: FUNCTION [G, K]; in_ascending_order: BOOLEAN)
		do
			make_from_values (list, sort_key)
			sort (in_ascending_order)
		end

feature {NONE} -- Implementation

	less_than (a, b: like item): BOOLEAN
		do
			Result := a.key < b.key
		end

end
