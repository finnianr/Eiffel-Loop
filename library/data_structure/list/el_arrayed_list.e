note
	description: "Summary description for {EL_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ARRAYED_LIST [G]

inherit
	ARRAYED_LIST [G]

	EL_CHAIN [G]
		undefine
			off, index_of, occurrences, has, do_all, do_if, there_exists, for_all, is_equal, search, copy,
			i_th, at, last, first, valid_index, is_inserted, move, start, finish, go_i_th, put_i_th,
			force, append, prune, prune_all, remove, swap
		redefine
			find_next
		end

create
	make, make_filled, make_from_array

feature -- Basic operations

	find_next (a_value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
			-- Find next item where function returns a value matching 'a_value'
		local
			l_area: like area_v2
			i, nb: INTEGER
			l_found: BOOLEAN
			l_tuple: TUPLE
		do
			if is_empty then
				create l_tuple
			else
				l_tuple := [first]
			end
			l_area := area_v2
			nb := count - 1
			if before_find then
				i := 0; before_find := False
			else
				i := index
			end
			from until i > nb or l_found loop
				l_tuple.put (l_area.item (i), 1)
				if a_value ~ value_function.item (l_tuple) then
					l_found := True
				else
					i := i + 1
				end
			end
			index := i + 1
		end

end
