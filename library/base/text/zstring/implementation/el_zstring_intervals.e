note
	description: "Traverseable intervals for [$source ZSTRING] including both encoded and unencoded"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-15 13:52:36 GMT (Wednesday 15th February 2023)"
	revision: "1"

deferred class
	EL_ZSTRING_INTERVALS [G, H -> READABLE_INDEXABLE [G]]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			lower as lower_index,
			upper as upper_index
		end

	EL_INTERVAL_CONSTANTS
		export
			{NONE} all
		end

	STRING_HANDLER undefine copy, is_equal, out end

	EL_SHARED_ZSTRING_CODEC

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

feature -- Element change

	set (a_unencoded_area: like unencoded_area; start_index, end_index: INTEGER)
		local
			i, lower, upper, overlap_status: INTEGER; l_unencoded_area: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES
		do
			wipe_out
			unencoded_area := a_unencoded_area; l_unencoded_area := a_unencoded_area
			if l_unencoded_area.count > 0 then
				searching := True
				from i := 0 until done or else i = l_unencoded_area.count loop
	--					[start_index, end_index] is A interval
					lower := l_unencoded_area [i].code; upper := l_unencoded_area [i + 1].code -- is B interval
					overlap_status := ir.overlap_status (start_index, end_index, lower, upper)
					if searching and then ir.is_overlapping (overlap_status) then
						searching := False
					end
					if not searching then
						if is_empty then
							if start_index < lower then
								extend (start_index, lower - 1)
							end

						elseif ir.is_overlapping (overlap_status) and then (lower - last_upper) >= 1 then
							extend (last_upper + 1, lower - 1)
						end
						inspect overlap_status
							when A_overlaps_B_left then
								extend (lower, end_index)
							when A_overlaps_B_right then
								extend (start_index, upper)
							when A_contains_B then
								extend (lower, upper)
							when B_contains_A then
								extend (start_index, end_index)
						else
							done := True
						end
					end
					i := i + upper - lower + 3
				end
				if is_empty then
					extend (start_index, end_index)
				elseif end_index > last_upper then
					extend (last_upper + 1, end_index)
				end
			else
				extend (start_index, end_index)
			end
		end

feature -- Status query

	same_characters (
		encoded_area: SPECIAL [CHARACTER_8]; other: like new_string_cursor; offset_other_to_current: INTEGER

	): BOOLEAN
		require
			not_empty: not is_empty
		local
			i, intervals_count, l_count, lower, upper, start_index: INTEGER
			intervals_area: SPECIAL [INTEGER_64]; l_codec: like Codec
		do
			intervals_area := area; intervals_count := count; l_codec := Codec
			start_index := (encoded_area [first_lower - 1] = Substitute).to_integer

			Result := True
			from i := start_index until not Result or else i >= intervals_count loop
				lower := (intervals_area [i] |>> 32).to_integer_32
				upper := intervals_area [i].to_integer_32
				l_count := upper - lower + 1
				Result := same_encoded_interval_characters (
					l_codec, encoded_area, l_count, lower - 1, offset_other_to_current, other
				)
				i := i + 2 -- every second one is encoded
			end
			if Result then
				start_index := (not start_index.to_boolean).to_integer
				Result := same_intervals (start_index, offset_other_to_current, other)
			end
		end

	same_intervals (list_start_index, a_other_offset: INTEGER; other: like new_string_cursor): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current `list' starting at index `index_pos'.
		local
			list_count, l_count, other_offset, overlap_status, comparison_count: INTEGER
			i, list_i, start_index, end_index, lower, upper, other_i, current_i: INTEGER
			l_unencoded_area: like unencoded_area; l_area: like area; ir: EL_INTERVAL_ROUTINES
			o_area: SPECIAL [G]
		do
			l_unencoded_area := unencoded_area
			if is_empty then
				Result := True
			else
				o_area := cursor_area (other); other_offset := a_other_offset + area_first_index (other)

				list_i := list_start_index; list_count := count; l_area := area
				Result := True
				from i := 0 until not Result or else list_i >= list_count or else i = l_unencoded_area.count loop
					start_index := (l_area [list_i] |>> 32).to_integer_32 -- A interval
					end_index := l_area [list_i].to_integer_32 -- A interval
					lower := l_unencoded_area [i].code; upper := l_unencoded_area [i + 1].code -- B interval
					l_count := upper - lower + 1

					overlap_status := ir.overlap_status (start_index, end_index, lower, upper)
					if ir.is_overlapping (overlap_status) then
						inspect overlap_status
							when A_overlaps_B_left then
								comparison_count := end_index - lower + 1
								other_i := other_offset + lower - 1
								current_i := i + 2 + lower - start_index

							when A_overlaps_B_right then
								comparison_count := upper - start_index + 1
								other_i := other_offset + start_index - 1
								current_i := i + 2 + start_index - lower

							when A_contains_B then
								comparison_count := l_count
								other_i := other_offset + lower - 1
								current_i := i + 2 + lower - start_index

							when B_contains_A then
								comparison_count := end_index - start_index + 1
								other_i := other_offset + lower + (start_index - lower) - 1
								current_i := i + 2 + start_index - lower
						end
						Result := same_interval_characters (l_unencoded_area, o_area, other_i, current_i, comparison_count)
						list_i := list_i + 2 -- every 2nd interval is unencoded
					end
					i := i + l_count + 2
				end
			end
		end

feature {NONE} -- Implementation

	area_first_index (a_cursor: like new_string_cursor): INTEGER
		deferred
		end

	cursor_area (a_cursor: like new_string_cursor): SPECIAL [G]
		deferred
		end

	new_string_cursor: GENERAL_SPECIAL_ITERATION_CURSOR [G, H]
		deferred
		end

	same_encoded_interval_characters (
		a_codec: like codec; encoded_area: SPECIAL [CHARACTER]
		a_count, offset, a_other_offset: INTEGER; other: like new_string_cursor
	): BOOLEAN
		deferred
		end

	same_interval_characters (
		current_area: like unencoded_area; other_area: SPECIAL [G]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	unencoded_area: SPECIAL [CHARACTER_32]
end