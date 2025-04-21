note
	description: "Split immutable UTF 8 list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 16:13:54 GMT (Sunday 20th April 2025)"
	revision: "21"

class
	EL_SPLIT_IMMUTABLE_UTF_8_LIST

inherit
	EL_SPLIT_IMMUTABLE_STRING_8_LIST
		rename
			make as make_split,
			character_count as utf_8_byte_count,
			i_th_count as i_th_utf_8_count,
			item_count as utf_8_item_count
		redefine
			less_than, item_index_of, is_utf_8_encoded, new_cursor, unicode_count
		end

	EL_UTF_8_CONVERTER_I
		rename
			storage_count as utf_8_storage_count,
			unicode_count as utf_8_unicode_count,
			substring_8_into_string_general as utf_8_substring_into_string_general
		end

	EL_SHARED_CHARACTER_AREA_ACCESS

	EL_MODULE_ITERABLE

	EL_SHARED_UTF_8_SEQUENCE

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make, make_split

feature {NONE} -- Initialization

	make (general_list: ITERABLE [READABLE_STRING_GENERAL])
		require
			no_commas: across general_list as list all not list.item.has (',') end
		local
			utf_8_csv_list: STRING_8
		do
			create utf_8_csv_list.make (utf_8_storage_count (general_list, 1))
			across general_list as list loop
				if utf_8_csv_list.count > 0 then
					utf_8_csv_list.append_character (',')
				end
				super_readable_general (list.item).append_to_utf_8 (utf_8_csv_list)
			end
			make_split (utf_8_csv_list, ',')
		end

feature -- Access

	new_cursor: EL_SPLIT_UTF_8_IMMUTABLE_STRING_8_ITERATION_CURSOR
		do
			create Result.make (Current)
		end

feature -- Status query

	Is_utf_8_encoded: BOOLEAN = True

feature -- Measurement

	unicode_count: INTEGER
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

	item_index_of (uc: CHARACTER_32): INTEGER
		-- index of `uc' relative to `item_start_index - 1'
		-- 0 if `uc' does not occurr within item bounds
		local
			index_lower: INTEGER
		do
			if attached Character_area_8.get_lower (target_string, $index_lower) as l_area then
				Result := Utf_8_sequence.character_index_of (uc, l_area, item_lower - 1, item_upper - 1)
			end
		end

feature {NONE} -- Implementation

	less_than (i, j: INTEGER): BOOLEAN
		local
			index_lower, left_index, right_index, left_count, right_count: INTEGER
		do
			if attached Utf_8_sequence as utf_8
				and then attached Character_area_8.get_lower (target_string, $index_lower) as t_area
				and then attached area as a
			then
				left_index := a [i] - 1
				left_count := array_unicode_count (t_area, left_index, a [i + 1] - 1)

				right_index := a [j] - 1
				right_count := array_unicode_count (t_area, right_index, a [j + 1] - 1)

				if right_count = left_count then
					Result := utf_8.strict_comparison (t_area, t_area, right_index, left_index, right_count) > 0
				else
					if left_count < right_count then
						Result := utf_8.strict_comparison (t_area, t_area, right_index, left_index, left_count) >= 0
					else
						Result := utf_8.strict_comparison (t_area, t_area, right_index, left_index, right_count) > 0
					end
				end
			end
		end

	target_substring_count (start_index, end_index: INTEGER): INTEGER
		do
			Result := utf_8_unicode_count (shared_target_substring (start_index, end_index))
		end

end