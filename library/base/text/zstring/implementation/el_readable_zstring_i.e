note
	description: "Access to routines for classes inherited by ${EL_READABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 12:16:01 GMT (Monday 1st April 2024)"
	revision: "9"

deferred class
	EL_READABLE_ZSTRING_I

inherit
	EL_SHARED_CLASS_ID

	EL_SHARED_ENCODINGS; EL_SHARED_IMMUTABLE_8_MANAGER; EL_SHARED_ZSTRING_CODEC

	EL_SHARED_UTF_8_SEQUENCE; EL_SHARED_STRING_32_CURSOR

feature -- Contract Support

	substitution_marker_count: INTEGER
		-- count of unescaped template substitution markers '%S' AKA '#'
		deferred
		end

feature {NONE} -- Measurement

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		deferred
		end

	internal_leading_white_space (a_area: SPECIAL [CHARACTER]; a_count: INTEGER): INTEGER
		deferred
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the begining
		deferred
		ensure
			substring_agrees: substring (1, Result).occurrences (uc) = Result
		end

	leading_white_space: INTEGER
		deferred
		end

	occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		deferred
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the end
		deferred
		ensure
			substring_agrees: substring (count - Result + 1, count).occurrences (uc) = Result
		end

	trailing_white_space: INTEGER
		deferred
		end

	utf_8_byte_count: INTEGER
		deferred
		end

feature {NONE} -- Status query

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		deferred
		end

	is_reversible_z_code_pattern (general: READABLE_STRING_GENERAL; z_code_string: STRING_32): BOOLEAN
		deferred
		end

	is_valid_as_string_8: BOOLEAN
		deferred
		end

	same_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, start_index: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		deferred
		end

	same_string (other: READABLE_STRING_32): BOOLEAN
		deferred
		end

feature {NONE} -- Implementation

	append_z_code (c: NATURAL)
		deferred
		end

	as_lower: like Current
		deferred
		end

	as_upper: like Current
		deferred
		end

	count: INTEGER
		deferred
		end

	current_readable: EL_READABLE_ZSTRING
		deferred
		end

	current_zstring: ZSTRING
		deferred
		end

	empty_occurrence_intervals (i: INTEGER): EL_OCCURRENCE_INTERVALS
		require
			valid_index: 0 <= i and i <= 1
		deferred
		end

	fill_with_z_code (str: STRING_32)
		deferred
		ensure
			reversible: is_reversible_z_code_pattern (current_readable, str)
		end

	internal_substring_index_list (str: READABLE_STRING_GENERAL): ARRAYED_LIST [INTEGER]
		deferred
		end

	internal_substring_intervals (str: READABLE_STRING_GENERAL): EL_OCCURRENCE_INTERVALS
		deferred
		end

	item_8 (index: INTEGER): CHARACTER
		deferred
		end

	make (n: INTEGER)
		-- Allocate space for at least `n' characters.
		deferred
		end

	make_from_other (other: EL_CONVERTABLE_ZSTRING)
		deferred
		end

	make_from_zcode_area (zcode_area: SPECIAL [NATURAL])
		deferred
		end

	new_string (n: INTEGER): like Current
		deferred
		end

	reset_hash
		deferred
		end

	substitution_marker_index_list: ARRAYED_LIST [INTEGER]
		-- shared list of indices of unescaped template substitution markers '%S' AKA '#'
		deferred
		ensure
			valid_result: across Result as index all item_8 (index.item) = '%S' end
		end

	substring (start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		deferred
		end

	to_string_32: STRING_32
		deferred
		end


end