note
	description: "[
		Memory efficient list of ${ZSTRING} with character data stored as a single
		UTF-8 encoding instance of ${IMMUTABLE_STRING_8} using class
		${EL_SPLIT_IMMUTABLE_UTF_8_LIST}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 14:15:32 GMT (Wednesday 16th April 2025)"
	revision: "30"

class
	EL_COMPACT_ZSTRING_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [ZSTRING]
		rename
			make as make_split
		undefine
			bit_count
		redefine
			at, count, default_target, do_meeting, extended_string, i_th, item, item_index_of,
			make_empty, new_cursor, sort
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_general

feature {NONE} -- Initialization

	make (a_utf_8_list: like utf_8_list)
		do
			utf_8_list := a_utf_8_list
			make_empty
		end

	make_general (general_list: ITERABLE [READABLE_STRING_GENERAL])
		require
			no_commas: not across general_list as list some list.item.has (',') end
		do
			make (create {EL_SPLIT_IMMUTABLE_UTF_8_LIST}.make (general_list))
		end

	make_empty
		do
			Precursor
			if not attached utf_8_list then
				create {EL_IMMUTABLE_UTF_8_LIST} utf_8_list.make_empty
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
		-- 0 if `uc' does not occur within item bounds
		do
			utf_8_list.go_i_th (index)
			Result := utf_8_list.item_index_of (uc)
		end

feature -- Access

	item: ZSTRING
		do
			create Result.make_from_utf_8 (utf_8_list [index])
		end

	item_utf_8: IMMUTABLE_STRING_8
		do
			Result :=  utf_8_list [index]
		end

	i_th alias "[]", at alias "@" (i: INTEGER): like item assign put_i_th
		do
			create Result.make_from_utf_8 (utf_8_list [i])
		end

	i_th_utf_8 (i: INTEGER): IMMUTABLE_STRING_8
		do
			Result :=  utf_8_list [i]
		end

	new_cursor: EL_COMPACT_ZSTRING_ITERATION_CURSOR
		do
			create Result.make (Current)
		end

feature -- Basic operations

	do_meeting (action: EL_CONTAINER_ACTION [ZSTRING]; condition: EL_QUERY_CONDITION [ZSTRING])
		-- perform `action' for each item meeting `condition'
		local
			i, l_count: INTEGER
		do
			l_count := count
			from i := 1 until i > l_count loop
				action.do_if (i_th (i), condition)
				i := i + 1
			end
		end

	sort (in_ascending_order: BOOLEAN)
		do
			utf_8_list.sort (in_ascending_order)
		end

feature {NONE} -- Implementation

	default_target: ZSTRING
		do
			Result := Empty_string
		end

	extended_string (general: ZSTRING): like super_z
		do
			Result := super_z (general)
		end

feature {EL_COMPACT_ZSTRING_ITERATION_CURSOR} -- Internal attributes

	utf_8_list:	EL_SORTABLE_STRING_LIST [IMMUTABLE_STRING_8]
end