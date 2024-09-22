note
	description: "Table to cache results of `new_item' creation procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:35:26 GMT (Sunday 22nd September 2024)"
	revision: "2"

deferred class
	EL_CACHE_TABLE [G, K -> HASHABLE]

inherit
	EL_HASH_TABLE [G, K]
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