note
	description: "[
		Routines to supplement handling of strings conforming to
		${READABLE_STRING_8} and ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:30:36 GMT (Monday 21st April 2025)"
	revision: "68"

deferred class
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE]

inherit
	EL_READABLE_STRING_GENERAL_ROUTINES_I
		rename
			occurrences as text_occurrences
		end

	EL_ROUTINES

	EL_CASE_CONTRACT

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_X]

	EL_SIDE_ROUTINES
		rename
			valid_side as valid_adjustments
		export
			{ANY} valid_adjustments
		end

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

	truncated (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			end
		end

feature -- Contract Support

	valid_substring_indices (str: READABLE_STRING_X; start_index, end_index: INTEGER): BOOLEAN
		do
			if str.valid_index (start_index) then
				Result := end_index >= start_index - 1 and end_index <= str.count
			end
		end

feature {NONE} -- Deferred

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL)
		deferred
		end

	split_on_character (str: READABLE_STRING_X; separator: CHAR): EL_SPLIT_ON_CHARACTER [READABLE_STRING_X, CHAR]
		deferred
		end

feature {NONE} -- Implementation

	substring_list (text: READABLE_STRING_X; intervals: EL_SEQUENTIAL_INTERVALS): EL_ARRAYED_LIST [READABLE_STRING_X]
		do
			create Result.make (intervals.count)
			from intervals.start until intervals.after loop
				Result.extend (text.substring (intervals.item_lower, intervals.item_upper))
				intervals.forth
			end
		end

	to_code (character: CHARACTER_32): NATURAL_32
		do
			Result := character.natural_32_code
		end

feature {NONE} -- Constants

	Once_occurence_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end

	Once_split_intervals: EL_SPLIT_INTERVALS
		once
			create Result.make_empty
		end

end