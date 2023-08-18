note
	description: "Hash table with [$source ZSTRING] as lookup key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 12:48:11 GMT (Friday 18th August 2023)"
	revision: "13"

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

	EL_ZSTRING_ROUTINES_IMP
		rename
			 as_zstring as new_key,
			 cursor as string_cursor,
			 wipe_out as string_wipe_out,
			 occurrences as string_occurrences,
			 replace as string_replace,
			 word_count as string_word_count
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

create
	default_create, make, make_size, make_equal, make_from_array

feature -- Status query

	has (key: READABLE_STRING_GENERAL): BOOLEAN
			-- Is there an item in the table with key `key'?
		do
			Result := table_has (to_z_key (key))
		end

	has_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		do
			Result := table_has_key (to_z_key (key))
		end

feature -- Basic operations

	search (key: READABLE_STRING_GENERAL)
			-- Search for item of key `key'.
			-- If found, set `found' to true, and set
			-- `found_item' to item associated with `key'.
		do
			table_search (to_z_key (key))
		end

feature {NONE} -- Implementation

	to_z_key (key: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} key as zstr then
				Result := zstr
			else
				Result := Buffer.copied_general (key)
			end
		end

end