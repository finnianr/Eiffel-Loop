note
	description: "Summary description for {EL_FILTERABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-25 0:31:51 GMT (Monday 25th December 2017)"
	revision: "3"

class
	EL_QUERYABLE_ARRAYED_LIST [G]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			make, make_filled, make_from_array
		end

	EL_QUERYABLE_CHAIN [G]
		undefine
			off, index_of, occurrences, has, do_all, do_if, there_exists, for_all, is_equal, search, copy,
			i_th, at, last, first, valid_index, is_inserted, move, start, finish, go_i_th, put_i_th,
			force, append, prune, prune_all, remove, swap, new_cursor
		end

create
	make, make_filled, make_from_array

feature -- Initialization

	make (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
		do
			make_chain
			Precursor (n)
		end

	make_filled (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
			-- This list will be full.
		do
			make_chain
			Precursor (n)
		end

	make_from_array (a: ARRAY [G])
			-- Create list from array `a'.
		do
			make_chain
			Precursor (a)
		end

end
