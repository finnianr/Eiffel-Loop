note
	description: "Storable string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

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
			put_i_th, i_th, go_i_th, new_cursor
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
