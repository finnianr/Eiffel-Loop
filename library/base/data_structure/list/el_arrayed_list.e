note
	description: "Summary description for {EL_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-18 14:03:26 GMT (Friday 18th November 2016)"
	revision: "2"

class
	EL_ARRAYED_LIST [G]

inherit
	ARRAYED_LIST [G]

	EL_CHAIN [G]
		undefine
			off, index_of, occurrences, has, do_all, do_if, there_exists, for_all, is_equal, search, copy,
			i_th, at, last, first, valid_index, is_inserted, move, start, finish, go_i_th, put_i_th,
			force, append, prune, prune_all, remove, swap, new_cursor
		redefine
			find_next_function_value
		end

create
	make, make_filled, make_from_array, make_empty

convert
	make_from_array ({ARRAY [G]})

feature {NONE} -- Initialization

	make_empty
		do
			make (0)
		end

feature {NONE} -- Implementation

	find_next_function_value (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
			-- Find next item where function returns a value matching 'a_value'
		local
			l_area: like area_v2; l_tuple: TUPLE [like item]
			i, nb: INTEGER; l_found: BOOLEAN
		do
			l_area := area_v2
			create l_tuple
			from nb := count - 1; i := index - 1 until i > nb or l_found loop
				l_tuple.put (l_area [i], 1)
				if value ~ value_function.item (l_tuple) then
					l_found := True
				else
					i := i + 1
				end
			end
			index := i + 1
		end

feature -- Element change

	append_array (array: ARRAY [G])
		do
			grow (count + array.count)
			array.do_all (agent extend)
		end

end
