note
	description: "Arrayed list of key-value pair tuples that can be sorted by value of type `G'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 8:23:56 GMT (Saturday 19th May 2018)"
	revision: "1"

class
	EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [K -> HASHABLE, G -> COMPARABLE]

inherit
	EL_SORTABLE_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table, make_sorted

feature {NONE} -- Implementation

	make_sorted (list: FINITE [K]; sort_value: FUNCTION [K, G]; in_ascending_order: BOOLEAN)
		local
			l_list: LINEAR [K]
		do
			make (list.count)
			l_list := list.linear_representation
			from l_list.start until l_list.after loop
				extend (l_list.item, sort_value (l_list.item))
				l_list.forth
			end
			sort (in_ascending_order)
		end

feature {NONE} -- Implementation

	less_than (a, b: like item): BOOLEAN
		do
			Result := a.value < b.value
		end

end
