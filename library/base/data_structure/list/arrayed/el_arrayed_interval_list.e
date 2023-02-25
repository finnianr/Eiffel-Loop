note
	description: "[
		Sequence of [$source INTEGER_32] intervals (compressed as [$source INTEGER_64]'s for better performance)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-24 12:34:25 GMT (Friday 24th February 2023)"
	revision: "7"

class
	EL_ARRAYED_INTERVAL_LIST

inherit
	EL_ARRAYED_LIST [INTEGER]
		rename
			circular_i_th as list_circular_i_th,
			extend as item_extend,
			first as item_first,
			last as item_last,
			lower as lower_index,
			upper as upper_index,
			replace as item_replace,
			remove_head as item_remove_head,
			remove_tail as item_remove_tail,
			put_i_th as item_put_i_th
		export
			{NONE} item_extend, item, i_th, item_put_i_th
		redefine
			count, grow, make, out, remove
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
			if attached area_v2 as l_area then
				from until i = l_area.count loop
					Result := Result + l_area [i + 1] - l_area [i] + 1
					i := i + 2
				end
			end
		end

feature -- Status query

	item_has (n: INTEGER): BOOLEAN
		do
			Result := area_item_has (area_v2, (index - 1) * 2, n)
		end

feature -- First item

	first_count: INTEGER
		do
			if attached area_v2 as a then
				Result := a [1] - a [0] + 1
			end
		end

	first_lower: INTEGER
		do
			Result := area_v2 [0]
		end

	first_upper: INTEGER
		do
			Result := area_v2 [1]
		end

feature -- i'th item

	i_th_compact (i: INTEGER): INTEGER_64
		require
			valid_index: valid_index (i)
		local
			j: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			j := (i - 1) * 2
			if attached area_v2 as a and then a.valid_index (j) then
				Result := ir.compact (a [j], a [j + 1])
			end
		end

	i_th_count (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		local
			j: INTEGER
		do
			j := (i - 1) * 2
			if attached area_v2 as a then
				Result := a [j + 1] - a [j] + 1
			end
		end

	i_th_lower (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area_v2 [(i - 1) * 2]
		end

	i_th_upper (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area_v2 [(i - 1) * 2 + 1]
		end

feature -- Cursor item

	item_count: INTEGER
		local
			j: INTEGER
		do
			j := (index - 1) * 2
			if attached area_v2 as a then
				Result := a [j + 1] - a [j] + 1
			end
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
		local
			j: INTEGER
		do
			j := (count - 1) * 2
			if attached area_v2 as a then
				Result := a [j + 1] - a [j] + 1
			end
		end

	last_lower: INTEGER
		do
			Result := area_v2 [(count - 1) * 2]
		end

	last_upper: INTEGER
		do
			Result := area_v2 [(count - 1) * 2 + 1]
		end

feature -- Conversion

	to_compact_array: ARRAY [INTEGER_64]
		local
			i: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			create Result.make_filled (0, 1, count)
			if attached area_v2 as l_area then
				from until i = l_area.count loop
					Result [i // 2 + 1] := ir.compact (l_area [i], l_area [i + 1])
					i := i + 2
				end
			end
		end

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (8 * count)
			if attached area_v2 as l_area then
				from until i = l_area.count loop
					if not Result.is_empty then
						Result.append (", ")
					end
					Result.append_character ('[')
					Result.append_integer (l_area [i])
					Result.append_character (':')
					Result.append_integer (l_area [i + 1])
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

			same_item: old i_th_compact (index) = i_th_compact (index)
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