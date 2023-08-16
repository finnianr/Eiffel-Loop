note
	description: "[
		Memory efficient list of [$source ZSTRING] with character data stored as a single
		UTF-8 encoding instance of [$source IMMUTABLE_STRING_8] using class
		[$source EL_SPLIT_IMMUTABLE_UTF_8_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:47:25 GMT (Tuesday 8th August 2023)"
	revision: "23"

class
	EL_COMPACT_ZSTRING_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [ZSTRING]
		rename
			make as make_split
		undefine
			bit_count
		redefine
			at, count, default_target, i_th, item, item_index_of,
			make_empty, new_cursor, sort
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

create
	make_empty, make

feature {NONE} -- Initialization

	make (general_list: ITERABLE [READABLE_STRING_GENERAL])
		require
			no_commas: across general_list as list all not list.item.has (',') end
		do
			create utf_8_list.make (general_list)
			make_empty
		end

	make_empty
		do
			Precursor
			if not attached utf_8_list then
				create utf_8_list.make_empty
			end
			object_comparison := True
		end

feature -- Measurement

	count: INTEGER
		-- interval count
		do
			Result := utf_8_list.count
		end

	item_index_of (uc: CHARACTER_32): INTEGER
		-- index of `uc' relative to `item_start_index - 1'
		-- 0 if `uc' does not occurr within item bounds
		do
			utf_8_list.go_i_th (index)
			Result := utf_8_list.item_index_of (uc)
		end

feature -- Access

	item: ZSTRING
		do
			create Result.make_from_utf_8 (utf_8_list [index])
		end

	i_th alias "[]", at alias "@" (i: INTEGER): like item assign put_i_th
		do
			create Result.make_from_utf_8 (utf_8_list [i])
		end

	new_cursor: EL_COMPACT_ZSTRING_ITERATION_CURSOR
		do
			create Result.make (Current)
		end

feature -- Basic operations

	sort (in_ascending_order: BOOLEAN)
		do
			utf_8_list.sort (in_ascending_order)
		end

feature {NONE} -- Implementation

	default_target: ZSTRING
		do
			Result := Empty_string
		end

feature {EL_COMPACT_ZSTRING_ITERATION_CURSOR} -- Internal attributes

	utf_8_list: EL_SPLIT_IMMUTABLE_UTF_8_LIST
end