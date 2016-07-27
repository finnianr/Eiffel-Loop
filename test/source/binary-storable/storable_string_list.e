note
	description: "Summary description for {STORABLE_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-02-07 12:47:46 GMT (Sunday 7th February 2016)"
	revision: "5"

class
	STORABLE_STRING_LIST

inherit
	EL_STORABLE_CHAIN [STORABLE_STRING]
		rename
			on_delete as do_nothing
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

	software_version: NATURAL
		-- Format of application version.
		do
		end

end