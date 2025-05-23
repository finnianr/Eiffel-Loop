note
	description: "Hash table with ${ZSTRING} as lookup key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:44 GMT (Sunday 30th March 2025)"
	revision: "20"

class
	EL_ZSTRING_HASH_TABLE [G]

inherit
	EL_STRING_HASH_TABLE [G, ZSTRING]
		undefine
			new_key
		end

	EL_STRING_GENERAL_ROUTINES_I
		rename
			 as_zstring as new_key
		end

create
	default_create, make_assignments, make, make_equal, make_from_tuples, make_one

feature -- Status query

	has_general (key: READABLE_STRING_GENERAL): BOOLEAN
			-- Is there an item in the table with key `key'?
		do
			Result := has (Buffer.to_same (key))
		end

	has_general_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		do
			Result := has_key (Buffer.to_same (key))
		end

feature -- Basic operations

	search_general (key: READABLE_STRING_GENERAL)
			-- Search for item of key `key'.
			-- If found, set `found' to true, and set
			-- `found_item' to item associated with `key'.
		do
			search (Buffer.to_same (key))
		end

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end
end