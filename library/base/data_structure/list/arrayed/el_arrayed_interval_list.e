note
	description: "[
		Sequence of [$source INTEGER_32] intervals (compressed as [$source INTEGER_64]'s for better performance)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-16 15:09:11 GMT (Thursday 16th March 2023)"
	revision: "13"

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
		redefine
			count, for_all_index, grow, make, out, remove, there_exists_index, new_cursor, upper_index
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n * 2)
		end

feature -- Measurement

	count: INTEGER
			-- Number of items.
		do
			Result := area_v2.count // 2
		end

	count_sum: INTEGER
		local
			i: INTEGER
		do
			if attached area_v2 as a then
				from until i = a.count loop
					Result := Result + a [i + 1] - a [i] + 1
					i := i + 2
				end
			end
		end

	upper_index: INTEGER
			-- Number of items.
		do
			Result := count
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

feature -- First item

	first_count: INTEGER
		do
			if count > 0 then
				Result := i_th_count (1)
			end
		end

	first_lower: INTEGER
		do
			if attached area_v2 as a and then a.count > 0 then
				Result := area_v2 [0]
			end
		end

	first_upper: INTEGER
		do
			if attached area_v2 as a and then a.count > 0 then
				Result := area_v2 [1]
			end
		end

feature -- i'th item

	i_th_compact (i: INTEGER): INTEGER_64
		require
			valid_index: valid_index (i)
		local
			lower, upper: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			lower := i_th_lower_upper (i, $upper)
			Result := ir.compact (lower, upper)
		end

	i_th_count (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		local
			lower, upper: INTEGER
		do
			lower := i_th_lower_upper (i, $upper)
			Result := upper - lower + 1
		end

	i_th_lower (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area_v2 [(i - 1) * 2]
		end

	i_th_lower_upper (i: INTEGER; upper_ptr: POINTER): INTEGER
		-- i'th lower index setting integer at `upper_ptr' memory location as a side-effect
		require
			attached_upper: upper_ptr /= default_pointer
		local
			p: EL_POINTER_ROUTINES; j, k: INTEGER
		do
			if attached area_v2 as a then
				j := (i - 1) * 2; k := j + 1
				if k < a.count then
					Result := a [j]
					p.put_integer_32 (a [k], upper_ptr)
				else
					Result := 1
				end
			else
				Result := 1
			end
		end

	i_th_upper (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area_v2 [(i - 1) * 2 + 1]
		end

feature -- Cursor item

	item_compact: INTEGER_64
		require
			valid_item: not off
		do
			if not off then
				Result := i_th_compact (index)
			end
		end

	item_count: INTEGER
		require
			valid_item: not off
		do
			Result := i_th_count (index)
		end

	item_interval: INTEGER_INTERVAL
		do
			Result := item_lower |..| item_upper
		end

	item_lower: INTEGER
		do
			Result := area_v2 [(index - 1) * 2]
		end

	item_upper: INTEGER
		do
			Result := area_v2 [(index - 1) * 2 + 1]
		end

feature -- Last item

	last_count: INTEGER
		do
			if count > 0 then
				Result := i_th_count (count)
			end
		end

	last_lower: INTEGER
		do
			if count > 0 then
				Result := i_th_lower (count)
			end
		end

	last_upper: INTEGER
		do
			if count > 0 then
				Result := i_th_upper (count)
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

	replace (a_lower, a_upper: INTEGER)
		require
			valid_item: not off
		local
			j: INTEGER
		do
			j := (index - 1) * 2
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
			shifted_by_one: old (index < count) implies i_th_compact (index) = old i_th_compact (index + 1)
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

	remove_item_head (n: INTEGER)
		require
			valid_item: not off
			within_limits: 0 <= n and n <= item_count
		local
			j: INTEGER
		do
			j := (index - 1) * 2
			if attached area_v2 as a then
				a [j] := a [j] + n
			end
		ensure
			valid_item_count: item_count = old item_count - n
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