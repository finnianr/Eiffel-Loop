note
	description: "Hash table with [$source ZSTRING] as lookup key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 17:02:51 GMT (Saturday 25th November 2023)"
	revision: "14"

class
	EL_ZSTRING_HASH_TABLE [G]

inherit
	EL_STRING_HASH_TABLE [G, ZSTRING]
		rename
			has_key as table_has_key,
			has as table_has,
			search as table_search
		export
			{NONE} table_has_key, table_has, table_search
		undefine
			new_key
		end

	EL_STRING_GENERAL_ROUTINES
		rename
			 as_zstring as new_key
		end

create
	default_create, make, make_size, make_equal, make_from_array

feature -- Status query

	has (key: READABLE_STRING_GENERAL): BOOLEAN
			-- Is there an item in the table with key `key'?
		do
			Result := table_has (Buffer.to_same (key))
		end

	has_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		do
			Result := table_has_key (Buffer.to_same (key))
		end

feature -- Basic operations

	search (key: READABLE_STRING_GENERAL)
			-- Search for item of key `key'.
			-- If found, set `found' to true, and set
			-- `found_item' to item associated with `key'.
		do
			table_search (Buffer.to_same (key))
		end

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end
end