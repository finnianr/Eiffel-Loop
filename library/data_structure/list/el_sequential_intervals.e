note
	description: "[
		Sequence of consecutive INTEGER_32 intervals (compressed as INTEGER_64's for better performance)
			
			<< a1..b1, a2..b2, .. >>
		
		such that b(n) < a(n + 1)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 14:44:18 GMT (Thursday 21st January 2016)"
	revision: "5"

class
	EL_SEQUENTIAL_INTERVALS

inherit
	ARRAYED_LIST [INTEGER_64]
		rename
			extend as item_extend,
			replace as item_replace
		redefine
			out
		end

create
	make

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

	item_count: INTEGER
		local
			l_item: like item
		do
			l_item := item
			Result := upper_integer (l_item) - lower_integer (l_item) + 1
		end

	count_sum: INTEGER
		local
			l_area: like area; i, l_count: INTEGER; l_item: like item
		do
			l_area := area; l_count := l_area.count
			from until i = l_count loop
				l_item := l_area [i]
				Result := Result + upper_integer (l_item) - lower_integer (l_item) + 1
				i := i + 1
			end
		end

	last_count: INTEGER
		local
			l_last: like last
		do
			l_last := last
			Result := upper_integer (l_last) - lower_integer (l_last) + 1
		end

	last_lower: INTEGER
		do
			Result := lower_integer (last)
		end

	last_upper: INTEGER
		do
			Result := upper_integer (last)
		end

	item_lower: INTEGER
		do
			Result := lower_integer (item)
		end

	item_interval: INTEGER_INTERVAL
		do
			Result := item_lower |..| item_upper
		end

	item_upper: INTEGER
		do
			Result := upper_integer (item)
		end

	out: STRING
		local
			l_area: like area; i, l_count: INTEGER; l_item: like item
		do
			create Result.make (8 * count)
			l_area := area; l_count := l_area.count
			from until i = l_count loop
				l_item := l_area [i]
				if not Result.is_empty then
					Result.append (", ")
				end
				Result.append_character ('[')
				Result.append_integer (lower_integer (l_item))
				Result.append_character (':')
				Result.append_integer (upper_integer (l_item))
				Result.append_character (']')
				i := i + 1
			end
		end

feature -- Status query

	has_overlapping (interval: INTEGER_64): BOOLEAN
		local
			pos: CURSOR
		do
			pos := cursor
			from start until Result or else after loop
				Result := item_has (lower_integer (interval.item)) or else item_has (upper_integer (interval.item))
				forth
			end
			go_to (pos)
		end

	item_has (n: INTEGER): BOOLEAN
		local
			l_item: like item
		do
			l_item := item
			Result := lower_integer (l_item) <= n and then n <= upper_integer (l_item)
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
			found: BOOLEAN
		do
			from finish until found or before loop
				if n < item_lower then
					remove; back
				elseif item_has (n) then
					replace (item_lower, n)
					found := True
				else
					back
				end
			end
		end

	cut_before (n: INTEGER)
		local
			found: BOOLEAN
		do
			from start until found or after loop
				if n > item_upper then
					remove
				elseif item_has (n) then
					replace (n, item_upper)
					found := True
				else
					forth
				end
			end
		end

	extend (a_lower, a_upper: INTEGER)
		require
			interval_after_last: not is_empty implies a_lower > last_upper
		do
			item_extend (new_item (a_lower, a_upper))
		ensure
			lower_extended: a_lower = last_lower
			upper_extended: a_upper = last_upper
		end

	extend_upper (a_upper: INTEGER)
		local
			l_last: like last
		do
			if is_empty then
				extend (a_upper, a_upper)
			else
				l_last := last
				if upper_integer (l_last) + 1 = a_upper then
					finish; item_replace (l_last + 1)
				else
					extend (a_upper, a_upper)
				end
			end
		end

	replace (a_lower, a_upper: INTEGER)
		do
			item_replace (a_lower.to_integer_64 |<< 32 | a_upper)
		end

feature -- Factory

	new_item (a_lower, a_upper: INTEGER): like item
		do
			Result := a_lower.to_integer_64 |<< 32 | a_upper
		end

feature {NONE} -- Implementation

	lower_integer (a_item: like item): INTEGER
		do
			Result := (a_item |>> 32).to_integer_32
		end

	upper_integer (a_item: like item): INTEGER
		do
			Result := a_item.to_integer_32
		end

end
