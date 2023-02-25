note
	description: "[
		Sequence of consecutive [$source INTEGER_32] intervals (compressed as [$source INTEGER_64]'s for better performance)
			
			<< a1..b1, a2..b2, .. >>
		
		such that b(n) < a(n + 1)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-24 11:30:43 GMT (Friday 24th February 2023)"
	revision: "13"

class
	EL_SEQUENTIAL_INTERVALS

inherit
	EL_ARRAYED_INTERVAL_LIST
		redefine
			extend
		end

create
	make, make_empty

feature -- Access

	between (a_lower, a_upper: INTEGER): INTEGER_INTERVAL
			-- interval between `item' and `other' item
		require
			not_overlapping: not item_overlaps (a_lower, a_upper)
		local
			l_lower, j: INTEGER
		do
			j := (index - 1) * 2
			if attached area_v2 as a then
				l_lower := a [j]

				if a_upper < l_lower then
					create Result.make (a_upper + 1, l_lower - 1)
				else
					create Result.make (a [j + 1] + 1, a_lower - 1)
				end
			else
				create Result.make (1, 0)
			end
		ensure
			other_before: a_upper < item_lower
								implies a_upper + 1 = Result.lower and Result.upper = item_lower - 1

			other_after: item_upper < a_lower
								implies item_upper + 1 = Result.lower and Result.upper = a_lower - 1
		end

feature -- Status query

	has_overlapping (lower, upper: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			if attached area_v2 as l_area then
				from until Result or i = l_area.count loop
					Result := area_item_has (l_area, i, lower) or else area_item_has (l_area, i, upper)
					i := i + 2
				end
			end
		end

	item_overlaps (a_lower, a_upper: INTEGER): BOOLEAN
		local
			l_lower, l_upper, j: INTEGER
		do
			if attached area_v2 as a then
				j := (index - 1) * 2
				l_lower := a [j]; l_upper := a [j + 1]
				Result := (a_lower <= l_lower and l_lower <= a_upper) or else
							  (a_lower <= l_upper and l_upper <= a_upper)
			end
		end

	overlaps (other: EL_SEQUENTIAL_INTERVALS): BOOLEAN
		local
			i: INTEGER
		do
			if attached area_v2 as l_area then
				from until Result or i = l_area.count loop
					Result := other.has_overlapping (l_area [i], l_area [i + 1])
					i := i + 2
				end
			end
		end

feature -- Element change

	cut_after (n: INTEGER)
		local
			l_found: BOOLEAN
		do
			from finish until l_found or before loop
				if n < item_lower then
					remove; back
				elseif item_has (n) then
					replace (item_lower, n)
					l_found := True
				else
					back
				end
			end
		end

	cut_before (n: INTEGER)
		local
			l_found: BOOLEAN
		do
			from start until l_found or after loop
				if n > item_upper then
					remove
				elseif item_has (n) then
					replace (n, item_upper)
					l_found := True
				else
					forth
				end
			end
		end

	extend (a_lower, a_upper: INTEGER)
		require else
			interval_after_last: not is_empty implies a_lower > last_upper
		do
			Precursor (a_lower, a_upper)
		end

end