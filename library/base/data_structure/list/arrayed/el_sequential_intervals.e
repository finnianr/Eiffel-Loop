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
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

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

	between (other: like item): like item
			-- interval between `item' and `other' item
		require
			not_overlapping: not item_overlaps (other)
		local
			other_upper, l_lower: INTEGER; l_item: like item
		do
			l_item := item
			l_lower := lower_integer (l_item)
			other_upper := upper_integer (other)
			if other_upper < l_lower then
				Result := new_item (other_upper + 1, l_lower - 1)
			else
				Result := new_item (upper_integer (l_item) + 1, lower_integer (other) - 1)
			end
		ensure
			other_before: upper_integer (other) < item_lower
								implies upper_integer (other) + 1 = lower_integer (Result)
											and upper_integer (Result) = item_lower - 1

			other_after: item_upper < lower_integer (other)
								implies item_upper + 1 = lower_integer (Result)
											and upper_integer (Result) = lower_integer (other) - 1
		end

feature -- Status query

	has_overlapping (interval: INTEGER_64): BOOLEAN
		local
			l_index: INTEGER
		do
			l_index := index
			from start until Result or else after loop
				Result := item_has (lower_integer (interval.item)) or else item_has (upper_integer (interval.item))
				forth
			end
			index := l_index
		end

	item_overlaps (other: like item): BOOLEAN
		local
			other_lower, other_upper, l_lower, l_upper: INTEGER
		do
			other_lower := lower_integer (other); other_upper := upper_integer (other)
			l_lower := item_lower; l_upper := item_upper
			Result := (other_lower <= l_lower and l_lower <= other_upper) or else
						  (other_lower <= l_upper and l_upper <= other_upper)
		end

	overlaps (other: EL_SEQUENTIAL_INTERVALS): BOOLEAN
		do
			Result := there_exists (agent other.has_overlapping)
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
			item_extend (new_item (a_lower, a_upper))
		end

end