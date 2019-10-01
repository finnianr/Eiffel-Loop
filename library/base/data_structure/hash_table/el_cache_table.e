note
	description: "Table to cache results of `new_item' creation procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 14:08:15 GMT (Tuesday   1st   October   2019)"
	revision: "2"

class
	EL_CACHE_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make as make_table,
			make_equal as make_equal_table,
			item as cached_item,
			remove as remove_type
		end

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item)
		do
			make_table (n)
			new_item := a_new_item
		end

	make_equal (n: INTEGER; a_new_item: like new_item)
		do
			make_equal_table (n)
			new_item := a_new_item
		end

feature -- Access

	item (key: K): like cached_item
			-- Returns the cached value of `new_item (key)' if available, or else
			-- the actual value
		do
			if has_key (key) then
				Result := found_item
			else
				Result := new_item (key)
				extend (Result, key)
			end
		end

feature {NONE} -- Initialization

	new_item: FUNCTION [K, G]

end
