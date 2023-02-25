note
	description: "Traverseable intervals for [$source ZSTRING] including both encoded and unencoded"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-24 10:45:37 GMT (Friday 24th February 2023)"
	revision: "7"

class
	EL_ZSTRING_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_sized
		redefine
			copy
		end

	EL_INTERVAL_CONSTANTS
		export
			{NONE} all
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_sized (10)
		end

feature -- Access

	first_index_of_encoded (encoded_area: SPECIAL [CHARACTER_8]): INTEGER
		-- zero based index of first interval that covers encoded characters in `encoded_area'
		do
			Result := (encoded_area [first_lower - 1] = Substitute).to_integer
		end

feature -- Element change

	set (a_unencoded_area: like unencoded_area; lower_A, upper_A: INTEGER)
		local
			i, lower_B, upper_B, overlap_status: INTEGER; l_unencoded: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES; l_area: like area
		do
			wipe_out
			unencoded_area := a_unencoded_area; l_unencoded := a_unencoded_area
			if l_unencoded.count > 0 then
				l_area := area_v2
				searching := True
				from i := 0 until done or else i = l_unencoded.count loop
	--				[lower_A, upper_A] is A interval
					lower_B := l_unencoded [i].code; upper_B := l_unencoded [i + 1].code -- is B interval
					overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					if searching and then ir.is_overlapping (overlap_status) then
						searching := False
					end
					if not searching then
--						ensure enough space for at least 3 more additions
						if l_area.count + 6 > l_area.capacity then
							l_area := l_area.aliased_resized_area (l_area.count + 6 + additional_space)
							area_v2 := l_area
						end
						if is_empty then
							if lower_A < lower_B then
								l_area.extend (lower_A); l_area.extend (lower_B - 1)
							end

						elseif ir.is_overlapping (overlap_status) and then (lower_B - last_upper) >= 1 then
							l_area.extend (last_upper + 1); l_area.extend (lower_B - 1)
						end
						inspect overlap_status
							when A_overlaps_B_left then
								l_area.extend (lower_B); l_area.extend (upper_A)
							when A_overlaps_B_right then
								l_area.extend (lower_A); l_area.extend (upper_B)
							when A_contains_B then
								l_area.extend (lower_B); l_area.extend (upper_B)
							when B_contains_A then
								l_area.extend (lower_A); l_area.extend (upper_A)
						else
							done := True
						end
					end
					i := i + upper_B - lower_B + 3
				end
				if is_empty then
					l_area.extend (lower_A); l_area.extend (upper_A)
				elseif upper_A > last_upper then
					l_area.extend (last_upper + 1); l_area.extend (upper_A)
				end
			else
				extend (lower_A, upper_A)
			end
		end

feature -- Status query

	same_encoded_characters (
		encoded_area, other_encoded_area: SPECIAL [CHARACTER_8]; other: EL_ZSTRING_INTERVALS
	): BOOLEAN
		require
			not_empty: not is_empty
			similar_to_other: similar_to (other)
			valid_encoded_area: encoded_area.valid_index (last_upper -  1)
			valid_other_encoded_area: other_encoded_area.valid_index (other.last_upper -  1)
		local
			i, j, intervals_count, lower, upper, start_index, other_start_index: INTEGER
			l_area, o_area: like area_v2
		do
			l_area := area; o_area := other.area; intervals_count := count

			start_index := first_index_of_encoded (encoded_area)
			other_start_index := other.first_index_of_encoded (other_encoded_area)

			Result := start_index = other_start_index
			from i := start_index until not Result or else i >= intervals_count loop
				j := i * 2; lower := l_area [j]; upper := l_area [j + 1]
				Result := encoded_area.same_items (other_encoded_area, o_area [i] - 1, lower - 1, upper - lower + 1)
				i := i + 4 -- every second one is encoded
			end
		end

	similar_to (other: EL_ZSTRING_INTERVALS): BOOLEAN
		-- `True' if `Current' has the same count and size of intervals
		local
			l_area, o_area: like area; i, lower, upper, o_lower, o_upper: INTEGER
			l_unencoded_area, o_unencoded_area: like unencoded_area
		do
			l_area := area_v2; o_area := other.area_v2
			Result := l_area.count = o_area.count
			l_unencoded_area := unencoded_area; o_unencoded_area := other.unencoded_area
			from i := 0 until not Result or i = l_area.count loop
				lower := (l_area [i] |>> 32).to_integer_32
				upper := l_area [i].to_integer_32
				o_lower := (o_area [i] |>> 32).to_integer_32
				o_upper := o_area [i].to_integer_32
				Result := upper - lower = o_upper - o_lower
				i := i + 1
			end
		ensure
			same_intervals: Result implies count = other.count
					and then across 1 |..| count as n all i_th_count (n.item) = other.i_th_count (n.item) end
		end

feature -- Duplication

	copy (other: like Current)
		do
			Precursor {EL_SEQUENTIAL_INTERVALS} (other)
			unencoded_area := other.unencoded_area.twin
		end

feature -- Factory

	new_unencoded_sources (lower_A, upper_A: INTEGER): like area
		-- array of source and count indexes
		local
			i, l_index, lower_B, upper_B, l_count, overlap_status: INTEGER; l_unencoded: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES
		do
			create Result.make_empty (count // 2 + 1)
			l_unencoded := unencoded_area
			searching := True
			from i := 0 until done or else i = l_unencoded.count loop
--				[lower_A, upper_A] is A interval
				lower_B := l_unencoded [i].code; upper_B := l_unencoded [i + 1].code -- is B interval
				overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
				if searching then
					searching := not ir.is_overlapping (overlap_status)
				end
				if not searching then
					l_count := 0
					inspect overlap_status
						when A_overlaps_B_left then
							l_count := upper_A - lower_B + 1
							l_index := 0

						when A_overlaps_B_right then
							l_count := upper_B - lower_A + 1
							l_index := lower_A - lower_B

						when A_contains_B then
							l_count := upper_B - lower_B + 1
							l_index := 0

						when B_contains_A then
							l_count := upper_A - lower_A + 1
							l_index := lower_A - lower_B
					else
						done := True
					end
					if l_count.to_boolean then
						Result.extend (i + 2 + l_index)
						Result.extend (l_count)
					end
				end
				i := i + upper_B - lower_B + 3
			end
		end

feature {EL_ZSTRING_INTERVALS} -- Internal attributes

	unencoded_area: SPECIAL [CHARACTER_32]

end