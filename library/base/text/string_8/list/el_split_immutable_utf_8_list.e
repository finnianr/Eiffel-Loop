note
	description: "Split immutable UTF 8 list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 18:39:05 GMT (Saturday 5th April 2025)"
	revision: "16"

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
			append_lines_to, less_than, item_index_of, unicode_count
		end

	EL_UTF_8_CONVERTER
		rename
			unicode_count as substring_unicode_count,
			substring_8_into_string_general as utf_8_substring_into_string_general
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_STRING_GENERAL_ROUTINES_I

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
			utf_8_list: EL_STRING_8_LIST; utf_8_item: STRING_8
		do
			create utf_8_list.make (Iterable.count (general_list))
			across general_list as list loop
				if attached list.item as general then
					inspect string_storage_type (general)
						when '1' then
							if attached {STRING_8} general as str_8
								and then attached super_8 (str_8) as super_str_8
							then
								if super_str_8.is_ascii then
									utf_8_item := str_8
								else
									utf_8_item := super_str_8.to_utf_8
								end
							end
						when '4' then
							if attached {READABLE_STRING_32} general as str_32 then
								utf_8_item := super_readable_32 (str_32).to_utf_8
							end

						when 'X' then
							if attached {EL_READABLE_ZSTRING} general as zstr then
								utf_8_item := zstr.to_utf_8
							end
					end
					utf_8_list.extend (utf_8_item)
				end
			end
			make_split (utf_8_list.joined (','), ',')
		end

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
		do
			if attached cursor_8 (target_string) as c8 then
				Result := Utf_8_sequence.character_index_of (uc, c8.area, item_lower - 1, item_upper - 1)
			end
		end

feature -- Basic operations

	append_lines_to (output: STRING_GENERAL)
		local
			i: INTEGER
		do
			if attached area as a then
				from until i = a.count loop
					if output.count > 0 then
						output.append_code ({EL_ASCII}.Newline)
					end
					utf_8_substring_into_string_general (target_string, a [i], a [i + 1], output)
					i := i + 2
				end
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
			Result := substring_unicode_count (shared_target_substring (start_index, end_index))
		end

end