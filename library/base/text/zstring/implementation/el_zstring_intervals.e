note
	description: "Traverseable intervals for [$source ZSTRING] including both encoded and unencoded"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 10:34:05 GMT (Thursday 16th February 2023)"
	revision: "4"

class
	EL_ZSTRING_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			lower as lower_index,
			make as make_sized,
			upper as upper_index
		end

	EL_INTERVAL_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_sized (10)
		end

feature -- Element change

	set (a_unencoded_area: like unencoded_area; start_index, end_index: INTEGER)
		local
			i, lower, upper, overlap_status: INTEGER; l_unencoded: like unencoded_area
			searching, done: BOOLEAN; ir: EL_INTERVAL_ROUTINES; l_area: like area
		do
			wipe_out
			unencoded_area := a_unencoded_area; l_unencoded := a_unencoded_area
			if l_unencoded.count > 0 then
				l_area := area
				searching := True
				from i := 0 until done or else i = l_unencoded.count loop
	--				[start_index, end_index] is A interval
					lower := l_unencoded [i].code; upper := l_unencoded [i + 1].code -- is B interval
					overlap_status := ir.overlap_status (start_index, end_index, lower, upper)
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
							if start_index < lower then
								l_area.extend (new_item (start_index, lower - 1))
							end

						elseif ir.is_overlapping (overlap_status) and then (lower - last_upper) >= 1 then
							l_area.extend (new_item (last_upper + 1, lower - 1))
						end
						inspect overlap_status
							when A_overlaps_B_left then
								l_area.extend (new_item (lower, end_index))
							when A_overlaps_B_right then
								l_area.extend (new_item (start_index, upper))
							when A_contains_B then
								l_area.extend (new_item (lower, upper))
							when B_contains_A then
								l_area.extend (new_item (start_index, end_index))
						else
							done := True
						end
					end
					i := i + upper - lower + 3
				end
				if is_empty then
					l_area.extend (new_item (start_index, end_index))
				elseif end_index > last_upper then
					l_area.extend (new_item (last_upper + 1, end_index))
				end
			else
				extend (start_index, end_index)
			end
		end

feature -- Status query

	same_as (other: EL_ZSTRING_INTERVALS): BOOLEAN
		-- `True' if `Current' has the same count and size of intervals
		-- and the same `unencoded_area' for each interval
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
				if Result then
					Result := l_unencoded_area.same_items (o_unencoded_area, lower - 1, o_lower - 1, upper - lower + 1)
				end
				i := i + 1
			end
		ensure
			same_intervals: Result implies count = other.count
					and then across 1 |..| count as n all i_th_count (n.item) = other.i_th_count (n.item) end
		end

feature {EL_ZSTRING_INTERVALS} -- Internal attributes

	unencoded_area: SPECIAL [CHARACTER_32]

end