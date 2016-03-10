note
	description: "Summary description for {EL_FILTERABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FILTERABLE_ARRAYED_LIST [G]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			make, make_filled, make_from_array
		end

	EL_FILTERABLE_CHAIN [G]
		undefine
			off, index_of, occurrences, has, do_all, do_if, there_exists, for_all, is_equal, search, copy,
			i_th, at, last, first, valid_index, is_inserted, move, start, finish, go_i_th, put_i_th,
			force, append, prune, prune_all, remove, swap
		end

create
	make, make_filled, make_from_array

feature -- Initialization

	make (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
		do
			make_filterable
			Precursor (n)
		end

	make_filled (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
			-- This list will be full.
		do
			make_filterable
			Precursor (n)
		end

	make_from_array (a: ARRAY [G])
			-- Create list from array `a'.
		do
			make_filterable
			Precursor (a)
		end

end
