note
	description: "Base class for shared singleton cache table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:14:29 GMT (Sunday 24th December 2023)"
	revision: "1"

deferred class
	EL_SHAREABLE_CACHE_TABLE [G, K -> HASHABLE]

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	once_cache_table: HASH_TABLE [G, K]
		-- implement as once routine
		deferred
		end

	item (key: K): G
		do
			if Once_cache_table.has_key (key) then
				Result := Once_cache_table.found_item
			else
				Result := new_item (key)
				Once_cache_table.extend (Result, key)
			end
		end

	new_item (key: K): G
		deferred
		end

end