note
	description: "Deferred and implementation routines for class ${EL_READABLE_STRING_X_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-01 11:30:30 GMT (Tuesday 1st April 2025)"
	revision: "1"

deferred class
	EL_READABLE_STRING_X_ROUTINES_BASE [
		READABLE_STRING_X -> READABLE_STRING_GENERAL, C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_CASE
		rename
			is_valid as is_valid_case,
			Upper as Upper_case,
			Lower as Lower_case
		export
			{NONE} all
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_I

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_X]

	EL_SIDE_ROUTINES
		rename
			to_unicode_general as to_unicode,
			valid_sides as valid_adjustments
		export
			{ANY} as_zstring, ZSTRING, to_unicode, valid_adjustments
		end

	EL_STRING_8_CONSTANTS

	EL_ZSTRING_CONSTANTS
		rename
			String_searcher as ZString_searcher
		end

feature -- Contract Support

	valid_substring_indices (str: READABLE_STRING_X; start_index, end_index: INTEGER): BOOLEAN
		do
			if str.valid_index (start_index) then
				Result := end_index >= start_index - 1 and end_index <= str.count
			end
		end

feature {NONE} -- Deferred

	asterisk: C
		deferred
		end

	as_canonically_spaced (s: READABLE_STRING_X): READABLE_STRING_X
		-- copy of `s' with each substring of whitespace consisting of one space character (ASCII 32)
		deferred
		end

	cursor (s: READABLE_STRING_X): EL_STRING_ITERATION_CURSOR
		deferred
		end

	ends_with (s, trailing: READABLE_STRING_X): BOOLEAN
		deferred
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL)
		deferred
		end

	is_i_th_alpha (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical or numeric
		deferred
		end

	is_i_th_identifier (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is an identifier
		deferred
		end

	is_i_th_space (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is white space
		deferred
		end

	index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index: INTEGER): INTEGER
		deferred
		end

	last_index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	new_shared_substring (s: READABLE_STRING_X; start_index, end_index: INTEGER): READABLE_STRING_X
		deferred
		end

	same_string (a, b: READABLE_STRING_X): BOOLEAN
		deferred
		end

	split_on_character (str: READABLE_STRING_X; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER [READABLE_STRING_X]
		deferred
		end

	string_searcher: STRING_SEARCHER
		deferred
		end

	starts_with (s, leading: READABLE_STRING_X): BOOLEAN
		deferred
		end

feature {NONE} -- Implementation

	new_bracketed (str: READABLE_STRING_X; left_bracket: CHARACTER_32; right_to_left: BOOLEAN): READABLE_STRING_X
		-- substring of `str' enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		require
			valid_left_bracket: (create {EL_CHARACTER_32_ROUTINES}).is_left_bracket (left_bracket)
		local
			left_index, right_index: INTEGER; c32: EL_CHARACTER_32_ROUTINES
		do
			if right_to_left then
				left_index := last_index_of (str, left_bracket, str.count)
			else
				left_index := index_of (str, left_bracket, 1)
			end
			if left_index > 0 and then attached cursor (str) as l_cursor then
				right_index := index_of (str, c32.right_bracket (left_bracket), left_index + 1)
				right_index := l_cursor.matching_bracket_index (left_index)
				if right_index > 0 then
					Result := str.substring (left_index + 1, right_index - 1)
				else
					Result := str.substring (1, 0)
				end
			else
				Result := str.substring (1, 0)
			end
		end

	null: TYPED_POINTER [INTEGER]
		do
		end

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