note
	description: "Arrayed list of key-value pair tuples that can be sorted by value of type `G'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [K, G -> COMPARABLE]

inherit
	EL_SORTABLE_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from, make_empty, make_sorted, make_from_table

feature {NONE} -- Implementation

	make_sorted (container: CONTAINER [K]; sort_value: FUNCTION [K, G]; in_ascending_order: BOOLEAN)
		do
			make_from_keys (container, sort_value)
			sort (in_ascending_order)
		end

feature {NONE} -- Implementation

	less_than (a, b: like item): BOOLEAN
		do
			Result := a.value < b.value
		end

end