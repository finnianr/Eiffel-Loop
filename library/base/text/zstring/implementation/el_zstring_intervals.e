note
	description: "Traverseable intervals for [$source ZSTRING] including both encoded and unencoded"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 16:25:31 GMT (Thursday 16th February 2023)"
	revision: "5"

class
	EL_ZSTRING_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			lower as lower_index,
			make as make_sized,
			upper as upper_index
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

	set (a_unencoded_area: like unencoded_area; A_lower, A_upper: INTEGER)
		local
			i, B_lower, B_upper, overlap_status: INTEGER; l_unencoded: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES; l_area: like area
		do
			wipe_out
			unencoded_area := a_unencoded_area; l_unencoded := a_unencoded_area
			if l_unencoded.count > 0 then
				l_area := area
				searching := True
				from i := 0 until done or else i = l_unencoded.count loop
	--				[A_lower, A_upper] is A interval
					B_lower := l_unencoded [i].code; B_upper := l_unencoded [i + 1].code -- is B interval
					overlap_status := ir.overlap_status (A_lower, A_upper, B_lower, B_upper)
					if searching and then ir.is_overlapping (overlap_status) then
						searching := False
					end
					if not searching then
--						ensure enough space for at least 3 more additions
						if l_area.count + 3 > l_area.capacity then
							l_area := l_area.aliased_resized_area (i + additional_space)
							area_v2 := l_area
						end
						if is_empty then
							if A_lower < B_lower then
								l_area.extend (new_item (A_lower, B_lower - 1))
							end

						elseif ir.is_overlapping (overlap_status) and then (B_lower - last_upper) >= 1 then
							l_area.extend (new_item (last_upper + 1, B_lower - 1))
						end
						inspect overlap_status
							when A_overlaps_B_left then
								l_area.extend (new_item (B_lower, A_upper))
							when A_overlaps_B_right then
								l_area.extend (new_item (A_lower, B_upper))
							when A_contains_B then
								l_area.extend (new_item (B_lower, B_upper))
							when B_contains_A then
								l_area.extend (new_item (A_lower, A_upper))
						else
							done := True
						end
					end
					i := i + B_upper - B_lower + 3
				end
				if is_empty then
					l_area.extend (new_item (A_lower, A_upper))
				elseif A_upper > last_upper then
					l_area.extend (new_item (last_upper + 1, A_upper))
				end
			else
				extend (A_lower, A_upper)
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
			i, intervals_count, lower, upper, start_index, other_start_index: INTEGER
			intervals_area, other_intervals_area: SPECIAL [INTEGER_64]
			interval, other_interval: INTEGER_64
		do
			intervals_area := area; intervals_count := count
			other_intervals_area := other.area
			start_index := first_index_of_encoded (encoded_area)
			other_start_index := other.first_index_of_encoded (other_encoded_area)

			Result := start_index = other_start_index
			from i := start_index until not Result or else i >= intervals_count loop
				interval := intervals_area [i]; other_interval := other_intervals_area [i]
				lower := lower_integer (interval); upper := upper_integer (interval)
				Result := encoded_area.same_items (
					other_encoded_area, lower_integer (other_interval) - 1, lower - 1, upper - lower + 1
				)
				i := i + 2 -- every second one is encoded
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

	new_unencoded_sources (A_lower, A_upper: INTEGER): like area
		-- array of source and count indexes
		local
			i, l_index, B_lower, B_upper, l_count, overlap_status: INTEGER; l_unencoded: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES; str: IMMUTABLE_STRING_32
		do
			create Result.make_empty (count // 2 + 1)
			l_unencoded := unencoded_area
			searching := True
			from i := 0 until done or else i = l_unencoded.count loop
--				[A_lower, A_upper] is A interval
				B_lower := l_unencoded [i].code; B_upper := l_unencoded [i + 1].code -- is B interval
				overlap_status := ir.overlap_status (A_lower, A_upper, B_lower, B_upper)
				if searching then
					searching := not ir.is_overlapping (overlap_status)
				end
				if not searching then
					l_count := 0
					inspect overlap_status
						when A_overlaps_B_left then
							l_count := A_upper - B_lower + 1
							l_index := 0

						when A_overlaps_B_right then
							l_count := B_upper - A_lower + 1
							l_index := A_lower - B_lower

						when A_contains_B then
							l_count := B_upper - B_lower + 1
							l_index := 0

						when B_contains_A then
							l_count := A_upper - A_lower + 1
							l_index := A_lower - B_lower
					else
						done := True
					end
					if l_count.to_boolean then
						str := Immutable_32.new_substring (l_unencoded, i + 2 + l_index, l_count)
						Result.extend (new_item (i + 2 + l_index, l_count))
					end
				end
				i := i + B_upper - B_lower + 3
			end
		end

feature {EL_ZSTRING_INTERVALS} -- Internal attributes

	unencoded_area: SPECIAL [CHARACTER_32]

end