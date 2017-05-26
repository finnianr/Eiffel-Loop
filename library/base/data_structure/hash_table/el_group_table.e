note
	description: "[
		Table of grouped items defined by `key' function to `make' procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:16:37 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_GROUP_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [EL_ARRAYED_LIST [G], K]
		rename
			make as make_with_count
		end

create
	make

feature {NONE} -- Initialization

	make (key: FUNCTION [G, K]; list: INDEXABLE [G, INTEGER])
		-- Group items `list' into groups defined by `key' function
		local
			i: INTEGER; l_key: K
		do
			make_equal (((list.upper - list.lower + 1) // 10).min (11))
			from i := 1 until i > list.upper loop
				l_key := key (list [i])
				search (l_key)
				if not found then
					put (create {EL_ARRAYED_LIST [G]}.make (5), l_key)
				end
				found_item.extend (list [i])
				i := i + 1
			end
		end

end
