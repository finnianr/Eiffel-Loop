note
	description: "[
		Sequence of consecutive ${INTEGER_32} intervals (compressed as ${INTEGER_64}'s for better performance)
			
			<< a1..b1, a2..b2, .. >>
		
		such that b(n) < a(n + 1)
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 15:59:43 GMT (Wednesday 3rd April 2024)"
	revision: "18"

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
			-- interval between interval `item_lower' to `item_upper' and interval `a_lower' to `a_upper'
			-- assuming the intervals are not overlapping
		require
			valid_item: not off
			not_overlapping: not item_overlaps (a_lower, a_upper)
		local
			i, lower, upper: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				lower := a [i]; upper := a [i + 1]
			end
			if a_upper < lower then
				create Result.make (a_upper + 1, lower - 1)
			else
				create Result.make (upper + 1, lower - 1)
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
		-- `True' if interval at `index' overlaps with `a_lower' to `a_upper'
		require
			valid_item: not off
		local
			i: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			i := (index - 1) * 2
			if attached area as a then
				Result := ir.is_overlapping (ir.overlap_status (a [i], a [i + 1], a_lower, a_upper))
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

note
	descendants: "[
			EL_SEQUENTIAL_INTERVALS
				${JSON_INTERVALS_OBJECT [FIELD_ENUM -> EL_ENUMERATION_NATURAL_16 create make end]}
					${EL_IP_ADDRESS_META_DATA}
				${EL_ZSTRING_INTERVALS}
					${EL_COMPARABLE_ZSTRING_INTERVALS* [C, S -> READABLE_INDEXABLE [C]]}
						${EL_COMPARE_ZSTRING_TO_STRING_8}
							${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_8}
						${EL_COMPARE_ZSTRING_TO_STRING_32}
							${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_32}
				${EL_OCCURRENCE_INTERVALS}
					${EL_SPLIT_INTERVALS}
						${EL_ZSTRING_SPLIT_INTERVALS}
						${EL_STRING_8_SPLIT_INTERVALS}
						${EL_STRING_32_SPLIT_INTERVALS}
					${EL_ZSTRING_OCCURRENCE_INTERVALS}
						${EL_ZSTRING_SPLIT_INTERVALS}
						${EL_ZSTRING_OCCURRENCE_EDITOR}
					${JSON_PARSED_INTERVALS}
						${JSON_NAME_VALUE_LIST}
							${JSON_ZNAME_VALUE_LIST}
					${EL_STRING_8_OCCURRENCE_INTERVALS}
						${EL_STRING_8_SPLIT_INTERVALS}
						${EL_STRING_8_OCCURRENCE_EDITOR}
					${EL_STRING_32_OCCURRENCE_INTERVALS}
						${EL_STRING_32_SPLIT_INTERVALS}
						${EL_STRING_32_OCCURRENCE_EDITOR}
	]"
end