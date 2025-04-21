note
	description: "[
		${EL_ZSTRING_INTERVALS} that is comparable to string types other than ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 11:40:16 GMT (Sunday 20th April 2025)"
	revision: "9"

deferred class
	EL_COMPARABLE_ZSTRING_INTERVALS [CHAR -> COMPARABLE, S -> READABLE_INDEXABLE [CHAR]]

inherit
	EL_ZSTRING_INTERVALS
		redefine
			make, set
		end

	EL_SHARED_CHARACTER_AREA_ACCESS

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

	set_other_area (other: READABLE_INDEXABLE [CHAR])
		deferred
		end

feature -- Status query

	same_characters (encoded_area: SPECIAL [CHARACTER_8]; offset_other_to_current: INTEGER): BOOLEAN
		require
			not_empty: not is_empty
			other_area_set: is_other_area_set
		local
			i, intervals_count, l_count, lower, upper, start_index: INTEGER
			l_area: like area_v2
		do
			l_area := area; intervals_count := count
			start_index := (encoded_area [first_lower - 1] = Substitute).to_integer

			Result := True
			from i := start_index * 2 until not Result or else i >= intervals_count loop
				lower := l_area [i]; upper := l_area [i + 1]
				l_count := upper - lower + 1
				Result := same_encoded_interval_characters (
					encoded_area, l_count, lower - 1, offset_other_to_current
				)
				i := i + 4 -- every second one is encoded
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
			i, list_i, lower_A, upper_A, lower_B, upper_B, other_i, current_i: INTEGER
			l_unencoded: like unencoded_area; l_area: like area; ir: EL_INTERVAL_ROUTINES
			o_area: SPECIAL [CHAR]
		do
			l_unencoded := unencoded_area
			if is_empty then
				Result := True
			else
				o_area := other_area; other_offset := a_other_offset + other_area_first_index

				list_i := list_start_index * 2; list_count := count; l_area := area
				Result := True
				from i := 0 until not Result or else list_i >= list_count or else i = l_unencoded.count loop
					lower_A := l_area [list_i]; upper_A := l_area [list_i + 1]
					lower_B := l_unencoded [i].code; upper_B := l_unencoded [i + 1].code
					l_count := upper_B - lower_B + 1

					overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					if ir.is_overlapping (overlap_status) then
						inspect overlap_status
							when A_overlaps_B_left then
								comparison_count := upper_A - lower_B + 1
								other_i := lower_B - 1
								current_i := lower_B - lower_A

							when A_overlaps_B_right then
								comparison_count := upper_B - lower_A + 1
								other_i := lower_A - 1
								current_i := lower_A - lower_B

							when A_contains_B then
								comparison_count := l_count
								other_i := lower_B - 1
								current_i := lower_B - lower_A

							when B_contains_A then
								comparison_count := upper_A - lower_A + 1
								other_i := lower_B + (lower_A - lower_B) - 1
								current_i := lower_A - lower_B
						end
						Result := same_interval_characters (
							l_unencoded, o_area, other_offset +  other_i, i + 2 + current_i, comparison_count
						)
						list_i := list_i + 4 -- every 2nd interval is unencoded
					end
					i := i + l_count + 2
				end
			end
		end


feature {NONE} -- Deferred

	same_encoded_interval_characters (
		encoded_area: SPECIAL [CHARACTER]; a_count, offset, a_other_offset: INTEGER
	): BOOLEAN
		require
			all_area_is_encoded: is_encoded_area (encoded_area, a_count, offset)
		deferred
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [CHAR]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC

	unicode_table: SPECIAL [CHARACTER_32]

	other_area: SPECIAL [CHAR]

	default_other_area: SPECIAL [CHAR]

	other_area_first_index: INTEGER

end