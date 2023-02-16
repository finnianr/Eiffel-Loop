note
	description: "[
		[$source EL_ZSTRING_INTERVALS] that is comparable to string types other than [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 10:09:17 GMT (Thursday 16th February 2023)"
	revision: "1"

deferred class
	EL_COMPARABLE_ZSTRING_INTERVALS [G, H -> READABLE_INDEXABLE [G]]

inherit
	EL_ZSTRING_INTERVALS
		redefine
			make, set
		end

	STRING_HANDLER undefine copy, is_equal, out end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

	EL_SHARED_ZSTRING_CODEC
		rename
			Unicode_table as Shared_unicode_table,
			Codec as Shared_codec
		end

feature {NONE} -- Initialization

	make
		do
			Precursor
			codec := Shared_codec
			unicode_table := Shared_unicode_table
			create default_other_area.make_empty (0)
			other_area := default_other_area
		end

feature -- Element change

	set (a_unencoded_area: like unencoded_area; start_index, end_index: INTEGER)
		do
			Precursor (a_unencoded_area, start_index, end_index)
			other_area := default_other_area
		ensure then
			other_area_reset: other_area = default_other_area
		end

	set_other_area (a_cursor: like new_string_cursor)
		deferred
		end

feature -- Status query

	same_characters (encoded_area: SPECIAL [CHARACTER_8]; offset_other_to_current: INTEGER): BOOLEAN
		require
			not_empty: not is_empty
			other_area_set: is_other_area_set
		local
			i, intervals_count, l_count, lower, upper, start_index: INTEGER
			intervals_area: SPECIAL [INTEGER_64]
		do
			intervals_area := area; intervals_count := count
			start_index := (encoded_area [first_lower - 1] = Substitute).to_integer

			Result := True
			from i := start_index until not Result or else i >= intervals_count loop
				lower := (intervals_area [i] |>> 32).to_integer_32
				upper := intervals_area [i].to_integer_32
				l_count := upper - lower + 1
				Result := same_encoded_interval_characters (
					encoded_area, l_count, lower - 1, offset_other_to_current
				)
				i := i + 2 -- every second one is encoded
			end
			if Result then
				start_index := (not start_index.to_boolean).to_integer
				Result := same_intervals (start_index, offset_other_to_current)
			end
		end

	is_other_area_set: BOOLEAN
		do
			Result := other_area /= default_other_area
		end

feature -- Contract Support

	is_encoded_area (a_area: SPECIAL [CHARACTER]; a_count, offset: INTEGER): BOOLEAN
		local
			l_index: INTEGER
		do
			l_index := a_area.index_of (Substitute, offset)
			Result := not (offset <= l_index and l_index < offset + a_count - 1)
		end

feature {NONE} -- Implementation

	same_intervals (list_start_index, a_other_offset: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current `list' starting at index `index_pos'.
		local
			list_count, l_count, other_offset, overlap_status, comparison_count: INTEGER
			i, list_i, start_index, end_index, lower, upper, other_i, current_i: INTEGER
			l_unencoded: like unencoded_area; l_area: like area; ir: EL_INTERVAL_ROUTINES
			o_area: SPECIAL [G]
		do
			l_unencoded := unencoded_area
			if is_empty then
				Result := True
			else
				o_area := other_area; other_offset := a_other_offset + other_area_first_index

				list_i := list_start_index; list_count := count; l_area := area
				Result := True
				from i := 0 until not Result or else list_i >= list_count or else i = l_unencoded.count loop
					start_index := (l_area [list_i] |>> 32).to_integer_32 -- A interval
					end_index := l_area [list_i].to_integer_32 -- A interval
					lower := l_unencoded [i].code; upper := l_unencoded [i + 1].code -- B interval
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
						Result := same_interval_characters (l_unencoded, o_area, other_i, current_i, comparison_count)
						list_i := list_i + 2 -- every 2nd interval is unencoded
					end
					i := i + l_count + 2
				end
			end
		end

feature {NONE} -- Deferred

	new_string_cursor: GENERAL_SPECIAL_ITERATION_CURSOR [G, H]
		deferred
		end

	same_encoded_interval_characters (
		encoded_area: SPECIAL [CHARACTER]; a_count, offset, a_other_offset: INTEGER
	): BOOLEAN
		require
			all_area_is_encoded: is_encoded_area (encoded_area, a_count, offset)
		deferred
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [G]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC

	unicode_table: SPECIAL [CHARACTER_32]

	other_area: SPECIAL [G]

	default_other_area: SPECIAL [G]

	other_area_first_index: INTEGER

end