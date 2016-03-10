note
	description: "Summary description for {STORABLE_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	STORABLE_STRING_LIST

inherit
	EL_STORABLE_CHAIN [STORABLE_STRING]
		undefine
			valid_index, is_inserted, is_equal,
			first, last,
			do_all, do_if, there_exists, has, for_all,
			start, search, finish, at,
			append, swap, force, copy, prune_all, prune, move,
			put_i_th, i_th, go_i_th
		end

	ARRAYED_LIST [STORABLE_STRING]
		rename
			make as make_chain_implementation
		end

feature {NONE} -- Implementation

	new_item: like item
		do
			create Result.make_empty
		end

end
