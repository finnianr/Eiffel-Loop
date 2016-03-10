note
	description: "Summary description for {EL_HASH_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-15 13:14:27 GMT (Monday 15th July 2013)"
	revision: "2"

class
	EL_HASH_SET [G -> HASHABLE]

inherit
	HASH_TABLE [detachable G, detachable G]
		rename
			put as table_put,
			item_for_iteration as item,
			item as table_item,
			search as table_search,
			current_keys as as_list
		export
			{NONE} all
			{ANY} has, count, new_cursor, as_list
		end

	LINEAR [detachable G]
		rename
			has as has_item
		undefine
			copy, is_equal, off, search, linear_representation, occurrences, has_item
		end

create
	make, make_equal

feature -- Element change

	put (new: detachable G)
			--
		do
			table_put (new, new)
		end

feature -- Access

	index: INTEGER

feature -- Basic operations

	search (v: like item)
			--
		do

		end

feature {NONE} -- Unused

	finish
			--
		do
		end

end
