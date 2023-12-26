note
	description: "Base class for shared singleton cache table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 17:32:47 GMT (Monday 25th December 2023)"
	revision: "2"

deferred class
	EL_SHAREABLE_CACHE_TABLE [G, K -> HASHABLE]

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	once_cache_table: HASH_TABLE [G, K]
		-- implement as once routine
		deferred
		end

	shared_item (key: K): G
		do
			if attached once_cache_table as table then
				if table.has_key (key) then
					Result := table.found_item
				else
					Result := new_shared_item (key)
					table.extend (Result, key)
				end
			end
		end

	new_shared_item (key: K): G
		deferred
		end
end