note
	description: "Split immutable UTF 8 list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 7:23:48 GMT (Saturday 12th August 2023)"
	revision: "4"

class
	EL_SPLIT_IMMUTABLE_UTF_8_LIST

inherit
	EL_SPLIT_IMMUTABLE_STRING_8_LIST
		rename
			make as make_split,
			character_count as utf_8_character_count,
			i_th_count as i_th_utf_8_count,
			item_count as utf_8_item_count
		redefine
			less_than, item_index_of
		end

	EL_UTF_8_CONVERTER
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_MODULE_ITERABLE

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_UTF_8_SEQUENCE

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make, make_split

feature {NONE} -- Initialization

	make (general_list: ITERABLE [READABLE_STRING_GENERAL])
		require
			no_commas: across general_list as list all not list.item.has (',') end
		local
			utf_8_list: EL_STRING_8_LIST
		do
			create utf_8_list.make (Iterable.count (general_list))
			across general_list as list loop
				if attached {ZSTRING} list.item as zstr then
					utf_8_list.extend (zstr.to_utf_8 (True))

				elseif attached {READABLE_STRING_8} list.item as str_8
					and then cursor_8 (str_8).all_ascii
				then
					utf_8_list.extend (str_8)
				else
					utf_8_list.extend (utf_32_string_to_string_8 (list.item))
				end
			end
			make_split (utf_8_list.joined (','), ',')
		end

feature -- Measurement

	character_count: INTEGER
		local
			i: INTEGER
		do
			if attached area as a then
				from until i = a.count loop
					Result := Result + target_substring_count (a [i], a [i + 1])
					i := i + 2
				end
			end
		end

	i_th_count (a_i: INTEGER): INTEGER
		require
			valid_index: valid_index (a_i)
		local
			i: INTEGER
		do
			i := (a_i - 1) * 2
			if attached area as a then
				Result := target_substring_count (a [i], a [i + 1])
			end
		end

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		-- index of `uc' relative to `item_start_index - 1'
		-- 0 if `uc' does not occurr within item bounds
		do
			if attached cursor_8 (target_string) as c8 then
				Result := Utf_8_sequence.character_index_of (uc, c8.area, item_lower - 1, item_upper - 1)
			end
		end

feature {NONE} -- Implementation

	less_than (i, j: INTEGER): BOOLEAN
		local
			left_index, right_index, left_count, right_count: INTEGER
		do
			if attached Utf_8_sequence as utf_8 and then attached cursor_8 (target_string) as c8
				and then attached area as a
			then
				left_index := a [i] - 1
				left_count := array_unicode_count (c8.area, left_index, a [i + 1] - 1)

				right_index := a [j] - 1
				right_count := array_unicode_count (c8.area, right_index, a [j + 1] - 1)

				if right_count = left_count then
					Result := utf_8.strict_comparison (c8.area, c8.area, right_index, left_index, right_count) > 0
				else
					if left_count < right_count then
						Result := utf_8.strict_comparison (c8.area, c8.area, right_index, left_index, left_count) >= 0
					else
						Result := utf_8.strict_comparison (c8.area, c8.area, right_index, left_index, right_count) > 0
					end
				end
			end
		end

	target_substring_count (start_index, end_index: INTEGER): INTEGER
		do
			Result := unicode_count (shared_target_substring (start_index, end_index))
		end

end
