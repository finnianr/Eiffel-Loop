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

	EL_MODULE_ITERABLE

create
	make

feature {NONE} -- Initialization

	make (key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `key' function
		local
			l_key: K
		do
			make_equal ((Iterable.count (a_list) // 2).min (11))
			across a_list as l_list loop
				l_key := key (l_list.item)
				if has_key (l_key) then
					found_item.extend (l_list.item)
				else
					extend (create {like item}.make (5), l_key)
				end
			end
		end

end
