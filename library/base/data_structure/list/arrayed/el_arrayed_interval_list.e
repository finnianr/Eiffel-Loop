note
	description: "[
		Sequence of ${INTEGER_32} intervals (compressed as ${INTEGER_64}'s for better performance)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-20 7:24:11 GMT (Wednesday 20th September 2023)"
	revision: "19"

class
	EL_ARRAYED_INTERVAL_LIST

inherit
	EL_ARRAYED_LIST [INTEGER]
		rename
			circular_i_th as list_circular_i_th,
			extend as item_extend,
			for_all as for_all_index,
			first as item_first,
			last as item_last,
			lower as lower_index,
			upper as upper_index,
			put_i_th as item_put_i_th,
			replace as item_replace,
			remove_head as item_remove_head,
			remove_tail as item_remove_tail,
			there_exists as there_exists_index
		export
			{NONE} item_extend, item, i_th, item_put_i_th
		undefine
			count, upper_index
		redefine
			for_all_index, grow, make, out, remove, there_exists_index, new_cursor
		end

	EL_INTERVAL_LIST
		rename
			area as area_v2
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n * 2)
		end

feature -- Iterative query

	for_all_index (test: FUNCTION [INTEGER, BOOLEAN]): BOOLEAN
		-- Is `test' true for all item indices?
		require else
			target_is_list: test.target = Current
		local
			i, l_count: INTEGER
		do
			l_count := count
			Result := True
			from i := 1 until not Result or i > l_count loop
				Result := test (i)
				i := i + 1
			end
		end

	new_cursor: EL_ARRAYED_INTERVALS_CURSOR
			-- <Precursor>
		do
			create Result.make (Current)
		end

	some_interval_has (n: INTEGER): BOOLEAN
		do
			Result := there_exists_index (agent i_th_has (?, n))
		end

	there_exists_index (test: FUNCTION [INTEGER, BOOLEAN]): BOOLEAN
			-- Is `test' true for some item index?
		require else
			target_is_list: test.target = Current
		local
			i, l_count: INTEGER
		do
			l_count := count
			from i := 1 until Result or i > l_count loop
				Result := test (i)
				i := i + 1
			end
		end

feature -- Status query

	item_has (n: INTEGER): BOOLEAN
		-- `True' if interval at `index' contains `n'
		require
			valid_index: not off
		do
			Result := i_th_has (index, n)
		end

	i_th_has (i, n: INTEGER): BOOLEAN
		-- `True' if i'th interval contains `n'
		do
			Result := area_item_has (area_v2, (i - 1) * 2, n)
		end

	same_as (other: EL_ARRAYED_INTERVAL_LIST): BOOLEAN
		do
			if count = other.count then
				Result := area_v2.same_items (other.area_v2, 0, 0, count * 2)
			end
		end

feature -- Conversion

	to_compact_array: ARRAY [INTEGER_64]
		local
			i: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			create Result.make_filled (0, 1, count)
			if attached area_v2 as a then
				from until i = a.count loop
					Result [i // 2 + 1] := ir.compact (a [i], a [i + 1])
					i := i + 2
				end
			end
		end

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (8 * count)
			if attached area_v2 as a then
				from until i = a.count loop
					if not Result.is_empty then
						Result.append (", ")
					end
					Result.append_character ('[')
					Result.append_integer (a [i])
					Result.append_character (':')
					Result.append_integer (a [i + 1])
					Result.append_character (']')
					i := i + 2
				end
			end
		end

feature -- Element change

	extend_compact (compact_interval: NATURAL_64)
		do
			if compact_interval > 0 then
				extend ((compact_interval |>> 32).to_integer_32, compact_interval.to_integer_32)
			end
		end

	extend_next_upper (compact_interval: NATURAL_64; i: INTEGER): NATURAL_64
		-- performance optimized form of `extend_upper' with the `last_interval' tracked
		-- externally by a compact interval

		-- (Note: call `extend_compact' to finalize list after filling from an external loop)
		note

		local
			lower, upper: INTEGER
		do
			if compact_interval = 0 then
				lower := i; upper := i
			else
				lower := (compact_interval |>> 32).to_integer_32
				upper := compact_interval.to_integer_32
				if i = upper + 1 then
					upper := i
				else
					extend (lower, upper)
					lower := i; upper := i
				end
			end
			Result := (lower.to_natural_64 |<< 32) | upper.to_natural_64
		end

	extend (a_lower, a_upper: INTEGER)
		local
			i: INTEGER; l_area: like area_v2
		do
			i := count * 2 + 2
			l_area := area_v2
			if i > l_area.capacity then
				l_area := l_area.aliased_resized_area (i + additional_space)
				area_v2 := l_area
			end
			l_area.extend (a_lower); l_area.extend (a_upper)
		end

	extend_upper (a_upper: INTEGER)
		-- if `a_upper' = `last_upper + 1' then `last_upper' is incremented by one
		-- else a new interval `a_upper .. a_upper' is added
		do
			if is_empty then
				extend (a_upper, a_upper)

			elseif attached area_v2 as a and then a [a.count - 1] + 1 = a_upper then
				a [a.count - 1] := a_upper
			else
				extend (a_upper, a_upper)
			end
		end

	put_i_th (a_lower, a_upper, i: INTEGER)
		require
			valid_index: valid_index (i)
		local
			j: INTEGER
		do
			j := (i - 1) * 2
			if attached area_v2 as a then
				a [j] := a_lower; a [j + 1] := a_upper
			end
		end

feature -- Removal

	remove
			-- Remove current item.
			-- Move cursor to right neighbor
			-- (or `after' if no right neighbor)
		local
			i: INTEGER
		do
			if index < count then
				i := (index - 1) * 2
				area_v2.move_data (i + 2, i, (count - index) * 2)
			end
			area_v2.remove_tail (2)
		ensure then
			shifted_by_one: not off implies i_th_compact (index) = old next_compact_item
		end

	remove_head (n: INTEGER)
		do
			if n <= count and then attached area_v2 as l_area then
				l_area.move_data (n * 2, 0, (count - n) * 2)
				l_area.remove_tail (n * 2)
				if index > n then
					index := index - n
				end
			end
		ensure
			moved_items: n < old count
				implies old i_th_compact (n + 1) = i_th_compact (1) and old i_th_compact (count) = i_th_compact (count)

			same_item: old (not off and index > n) implies old item_compact = item_compact
		end

	remove_tail (n: INTEGER)
			--
		do
			if n <= count then
				area.remove_tail (n * 2)
			end
			if index > count + 1 then
				index := count + 1
			end
		ensure
			items_removed: to_compact_array ~ old to_compact_array.subarray (1, count - n)
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		do
			if i * 2 > area_v2.capacity then
				area_v2 := area_v2.aliased_resized_area (i * 2)
			end
		end

feature {NONE} -- Implementation

	area_item_has (a_area: like area; i, n: INTEGER): BOOLEAN
		do
			if attached area_v2 as a then
				Result := a [i] <= n and then n <= a [i + 1]
			end
		end

end