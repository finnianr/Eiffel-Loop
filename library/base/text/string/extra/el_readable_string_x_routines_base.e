note
	description: "Deferred and implementation routines for class ${EL_READABLE_STRING_X_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 16:03:42 GMT (Wednesday 16th April 2025)"
	revision: "11"

deferred class
	EL_READABLE_STRING_X_ROUTINES_BASE [
		RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_ROUTINES

	EL_CASE_CONTRACT

	EL_STRING_BIT_COUNTABLE [RSTRING]

	EL_SIDE_ROUTINES
		rename
			valid_side as valid_adjustments
		export
			{ANY} valid_adjustments
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		rename
			occurrences as text_occurrences
		end

	EL_STRING_8_CONSTANTS

	EL_ZSTRING_CONSTANTS
		rename
			String_searcher as ZString_searcher
		end

feature -- Contract Support

	valid_substring_indices (str: RSTRING; start_index, end_index: INTEGER): BOOLEAN
		do
			if str.valid_index (start_index) then
				Result := end_index >= start_index - 1 and end_index <= str.count
			end
		end

feature {NONE} -- Deferred

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: RSTRING; pattern: READABLE_STRING_GENERAL)
		deferred
		end

	same_string (a, b: RSTRING): BOOLEAN
		deferred
		end

	split_on_character (str: RSTRING; separator: CHAR): EL_SPLIT_ON_CHARACTER [RSTRING, CHAR]
		deferred
		end

feature {NONE} -- Implementation

	substring_list (text: RSTRING; intervals: EL_SEQUENTIAL_INTERVALS): EL_ARRAYED_LIST [RSTRING]
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