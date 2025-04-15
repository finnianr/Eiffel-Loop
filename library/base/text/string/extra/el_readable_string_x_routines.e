note
	description: "[
		Routines to supplement handling of strings conforming to
		${READABLE_STRING_8} and ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:00:18 GMT (Tuesday 15th April 2025)"
	revision: "66"

deferred class
	EL_READABLE_STRING_X_ROUTINES [
		READABLE_STRING_X -> READABLE_STRING_GENERAL, C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES_BASE [READABLE_STRING_X, C]

	EL_SHARED_FILLED_STRING_TABLES

feature -- Access

	occurrence_intervals (
		target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL; keep_ref: BOOLEAN

	): EL_OCCURRENCE_INTERVALS
		do
			Result := Once_occurence_intervals.emptied
			fill_intervals (Result, target, pattern)
			if keep_ref then
				Result := Result.twin
			end
		end

	split_intervals (target: READABLE_STRING_X; separator: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_SPLIT_INTERVALS
		do
			Result := Once_split_intervals.emptied
			fill_intervals (Result, target, separator)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Lists

	delimited_list (text: READABLE_STRING_X; delimiter: READABLE_STRING_GENERAL): like substring_list
		-- `text' split into arrayed list by `delimiter' string
		do
			Result := substring_list (text, split_intervals (text, delimiter, False))
		end

	to_csv_list (text: READABLE_STRING_X): like to_list
		-- left adjusted comma separated list
		do
			Result := to_list (text, ',', {EL_SIDE}.Left)
		end

	to_list (text: READABLE_STRING_X; uc: CHARACTER_32; adjustments: INTEGER): like substring_list
		-- `text' split by `uc' character and space adjusted according to `adjustments':
		-- `Both', `Left', `None', `Right' from class `EL_SIDE'.
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if attached Once_split_intervals.emptied as intervals then
				intervals.fill (text, uc, adjustments)
				Result := substring_list (text, intervals)
			end
		end

feature -- Comparison

	caseless_ends_with (big, small: READABLE_STRING_X): BOOLEAN
		-- `True' if `big.ends_with (small)' is true regardless of case of `small'
		do
			if small.is_empty then
				Result := True

			elseif big.count >= small.count then
				Result := occurs_caseless_at (big, small, big.count - small.count + 1)
			end
		end

	occurs_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		deferred
		end

	occurs_caseless_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		deferred
		end

	same_caseless (a, b: READABLE_STRING_X): BOOLEAN
		-- `True' `a' and `b' are the same regardless of case
		do
			if a.count = b.count then
				Result := occurs_caseless_at (a, b, 1)
			end
		end

feature -- Substring

	curtailed (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- `str' curtailed to `max_count' with added ellipsis where `max_count' is exceeded
		do
			if str.count > max_count - 2 then
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			else
				Result := str
			end
		end

	sandwiched_parts (str: READABLE_STRING_X; separator: CHARACTER_32; head_count, tail_count: INTEGER): READABLE_STRING_X
		-- joined substring of split list defined by `separator' after `head_count' and `tail_count' parts
		-- have been removed from head and tail of list respectively
		local
			start_index, end_index, index, first_cursor_index, last_cursor_index: INTEGER
		do
			if head_count + tail_count > 0 then
				if attached split_on_character (str, separator) as split_list then
					first_cursor_index := head_count + 1
					last_cursor_index := split_list.count - tail_count

					across split_list as list loop
						index := list.cursor_index
						if index = first_cursor_index then
							start_index := list.item_lower
						end
						if index = last_cursor_index then
							end_index := list.item_upper
						end
					end
					if start_index > 0 and end_index > 0 then
						Result := str.substring (start_index, end_index)
					else
						Result := str.substring (1, 0)
					end
				end
			else
				Result := str
			end
		end

	truncated (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			end
		end

end