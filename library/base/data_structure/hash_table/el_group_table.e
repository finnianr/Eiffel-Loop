note
	description: "[
		Table of grouped items defined by `key' function to `make' procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-31 11:28:23 GMT (Thursday 31st August 2017)"
	revision: "3"

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

	make (key: FUNCTION [G, K]; a_list: FINITE [G])
		-- Group items `list' into groups defined by `key' function
		local
			l_key: K; list: LINEAR [G]
		do
			make_equal ((a_list.count // 10).min (11))
			list := a_list.linear_representation
			from list.start until list.after loop
				l_key := key (list.item)
				search (l_key)
				if not found then
					put (create {EL_ARRAYED_LIST [G]}.make (5), l_key)
				end
				found_item.extend (list.item)
				list.forth
			end
		end

end
