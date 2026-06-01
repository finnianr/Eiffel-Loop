note
	description: "[
		Bucket array indexed by first letter (1st UTF-8 character) of ${C_STRING_8} XML tag/attribute names
		Intended for use with xpact as drop-in replacement for libexpat XML parser.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-06-01 13:10:33 GMT (Monday 1st June 2026)"
	revision: "1"

class C_NULLED_STRING_8_NAME_CACHE

inherit
	ARRAY [EL_KEY_INDEXED_ARRAYED_MAP_LIST [C_STRING_8, C_NULLED_STRING_8]]
		rename
			item as array_item,
			make as make_array
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			list: EL_ARRAYED_LIST [like array_item]; n8: NATURAL_8
		do
			create list.make_filled (n8.Max_value.to_integer_32, agent new_map_list)
			make_from_special (list.to_special)
		end

feature -- Access

	item (name: C_STRING_8): C_NULLED_STRING_8
		-- cached null terminated name for fixed length C string `name'
		-- creating one if it doesn't exist already
		require
			not_empty: name.count > 0
		do
			if attached array_item (name [1].code) as map_list then
				search (map_list, name)
				if map_list.after then
					create Result.make (name)
					map_list.extend (name, Result)
				else
					Result := map_list.item_value
				end
			end
		end

	used_count: INTEGER
		-- count of buckets that have items
		do
			across Current as list loop
				if list.item.count > 0 then
					Result := Result + 1
				end
			end
		end

feature {NONE} -- Implementation

	new_map_list (a_index: INTEGER): like array_item
		do
			create Result.make (10)
		end

	search (map_list: like new_map_list; name: C_STRING_8)
		do
			if map_list.count > Linear_search_count then
				map_list.binary_search (name)
			else
				map_list.start
				map_list.search_key (name)
			end
		end

feature {NONE} -- Constants

	Linear_search_count: INTEGER = 10
		-- threshold after which binary search starts to become more efficient

end
