note
	description: "Table to cache results of `new_item' creation procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:48:52 GMT (Monday 25th December 2023)"
	revision: "1"

deferred class
	EL_CACHE_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			item as cached_item
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

feature {NONE} -- Implementation

	new_item (key: K): G
		deferred
		end

end