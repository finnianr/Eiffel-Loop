note
	description: "[
		Routines acting on array of type [$source SPECIAL [INTEGER]] containing substring interval
		indices. The current item is determined by the implementation of **index**.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-27 11:12:09 GMT (Sunday 27th August 2023)"
	revision: "4"

deferred class
	EL_INTERVAL_LIST

inherit
	ANY
		undefine
			copy, is_equal, out
		end

feature -- Measurement

	count: INTEGER
		-- interval count
		do
			Result := area.count // 2
		end

	count_sum: INTEGER
		local
			i: INTEGER
		do
			if attached area as a then
				from until i = a.count loop
					Result := Result + a [i + 1] - a [i] + 1
					i := i + 2
				end
			end
		end

	non_zero_count: INTEGER
		do
			Result := count - zero_count
		end

	upper_index: INTEGER
			-- Number of items.
		do
			Result := count
		end

	zero_count: INTEGER
		-- count of all items with `item_count = 0'
		local
			i: INTEGER
		do
			if attached area as a then
				from until i = a.count loop
					if a [i + 1] - a [i] + 1 = 0 then
						Result := Result + 1
					end
					i := i + 2
				end
			end
		end

feature -- Interval query

	i_th_compact (i: INTEGER): INTEGER_64
		require
			valid_index: valid_index (i)
		local
			j: INTEGER
		do
			j := (i - 1) * 2
			if attached area as a then
				Result := (a [j].to_integer_64 |<< 32) | a [j + 1].to_integer_64
			end
		end

	i_th_count (a_i: INTEGER): INTEGER
		require
			valid_index: valid_index (a_i)
		local
			i: INTEGER
		do
			i := (a_i - 1) * 2
			if attached area as a then
				Result := a [i + 1] - a [i] + 1
			end
		end

	i_th_interval (a_i: INTEGER): INTEGER_INTERVAL
		local
			i: INTEGER
		do
			i := (a_i - 1) * 2
			if attached area as a then
				Result := a [i] |..| a [i + 1]
			end
		end

	i_th_lower (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area [(i - 1) * 2]
		end

	i_th_upper (i: INTEGER): INTEGER
		require
			valid_index: valid_index (i)
		do
			Result := area [(i - 1) * 2 + 1]
		end

feature -- First interval query

	first_count: INTEGER
		do
			if count > 0 then
				Result := i_th_count (1)
			end
		end

	first_lower: INTEGER
		do
			if attached area as a and then a.count > 0 then
				Result := a [0]
			end
		end

	first_upper: INTEGER
		do
			if attached area as a and then a.count > 0 then
				Result := a [1]
			end
		end

feature -- Last interval query

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

feature -- Cursor interval query

	item_compact: INTEGER_64
		require
			valid_item: not off
		do
			if valid_index (index) then
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
		require
			valid_item: not off
		do
			Result := i_th_interval (index)
		end

	item_lower: INTEGER
		do
			Result := area [(index - 1) * 2]
		end

	item_upper: INTEGER
		do
			Result := area [(index - 1) * 2 + 1]
		end

feature -- Element change

	replace (a_lower, a_upper: INTEGER)
		require
			valid_item: not off
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				a [i] := a_lower; a [i + 1] := a_upper
			end
		end

feature -- Removal

	remove_item_head (n: INTEGER)
		require
			valid_item: not off
			within_limits: 0 <= n and n <= item_count
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				a [i] := a [i] + n
			end
		ensure
			valid_item_count: item_count = old item_count - n
		end

feature -- Deferred

	area: SPECIAL [INTEGER]
		deferred
		end

	index: INTEGER
			-- Index of current position
		deferred
		end

	off: BOOLEAN
		-- Is there no current item?
		deferred
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		deferred
		end

feature {NONE} -- Contract support

	next_compact_item: INTEGER_64
		--
		local
			i: INTEGER
		do
			i := index + 1
			if valid_index (i) then
				Result := i_th_compact (i)
			end
		end

end