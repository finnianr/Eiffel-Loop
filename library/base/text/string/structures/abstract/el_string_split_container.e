note
	description: "[
		Abstraction representing container to be filled with split substrings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 7:01:10 GMT (Sunday 6th April 2025)"
	revision: "8"

deferred class
	EL_STRING_SPLIT_CONTAINER [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_SIDE_ROUTINES
		rename
			valid_side as valid_adjustments
		export
			{ANY} valid_adjustments
		end

	EL_LIST_ITEM_SUBSTRING_CONVERSION

	EL_STRING_BIT_COUNTABLE [S]

	EL_STRING_8_CONSTANTS

	EL_STRING_GENERAL_ROUTINES_I

feature {NONE} -- Initialization

	make (a_target: S; delimiter: CHARACTER_32)
		do
			make_empty
			fill (a_target, delimiter, 0)
		end

	make_adjusted (a_target: S; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill (a_target, delimiter, a_adjustments)
		end

	make_adjusted_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill_by_string (a_target, delimiter, a_adjustments)
		end

	make_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL)
		do
			make_empty
			fill_by_string (a_target, delimiter, 0)
		end

	make_empty
		do
			if not attached target then
				target := default_target
			end
		end

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		-- index of `uc' relative to `item_start_index - 1'
		-- 0 if `uc' does not occurr within item bounds
		local
			start_index, end_index, i: INTEGER
		do
			start_index := item_lower; end_index := item_upper
			from i := start_index until i > end_index or Result > 0 loop
				if same_i_th_character (target, i, uc) then
					Result := i - start_index + 1
				end
				i := i + 1
			end
		end

feature -- Status query

	left_adjusted: BOOLEAN
		do
			Result := has_left_side (adjustments)
		end

	right_adjusted: BOOLEAN
		do
			Result := has_right_side (adjustments)
		end

feature -- Element change

	fill (a_target: S; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
			fill_intervals (a_target, Empty_string_8, String_8_searcher, pattern, a_adjustments)
		end

	fill_by_string (a_target: S; pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
			fill_intervals_by_string (a_target, pattern, a_adjustments)
		end

	fill_general (a_target: READABLE_STRING_GENERAL; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill (l_target, pattern, a_adjustments)
			end
		end

	fill_general_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill_by_string (l_target, pattern, a_adjustments)
			end
		end

feature -- Deferred

	fill_intervals (
		a_target, a_pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; a_adjustments: INTEGER
	)
		deferred
		end

	fill_intervals_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		deferred
		end

	item: S
		deferred
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target
		end

feature {EL_SPLIT_READABLE_STRING_ITERATION_CURSOR} -- Implementation

	default_target: like item
		do
			create Result.make (0)
		end

	same_i_th_character (a_target: S; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc
		end

	set_target (a_target: S; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
		end

	extended_string (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			Result := super_readable_general (general)
		end

	string_strict_cmp (left_index, right_index, n: INTEGER): INTEGER
		local
			i, j, nb: INTEGER; i_code, j_code: NATURAL; done: BOOLEAN
		do
			from
				i := left_index; j := right_index; nb := i + n
			until
				done or else i = nb
			loop
				i_code := target [i].natural_32_code
				j_code := target [j].natural_32_code
				if i_code /= j_code then
					Result := (i_code - j_code).to_integer_32
					done := True
				end
				i := i + 1; j := j + 1
			end
		end

	target_substring (lower, upper: INTEGER): like item
		do
			Result := target.substring (lower, upper)
		end

feature {EL_STRING_SPLIT_CONTAINER, STRING_HANDLER} -- Internal attributes

	adjustments: INTEGER

	target: like item

end