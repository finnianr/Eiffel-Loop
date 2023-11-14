note
	description: "Aspect of [$source ZSTRING] as an array of 8-bit characters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-14 9:04:36 GMT (Tuesday 14th November 2023)"
	revision: "28"

deferred class
	EL_ZSTRING_CHARACTER_8_IMPLEMENTATION

inherit
	EL_SHARED_STRING_8_CURSOR; EL_SHARED_CLASS_ID

	STRING_HANDLER

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			set_count (0)
			create area.make_filled ('%/000/', n + 1)
		end

feature -- Access

	area: SPECIAL [CHARACTER_8]
			-- Storage for characters.

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER; l_area: like area
		do
			l_area := area
				-- The magic number `8388593' below is the greatest prime lower than
				-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
			from i := 0; nb := count until i = nb loop
				Result := ((Result \\ 8388593) |<< 8) + l_area.item (i).natural_32_code.to_integer_32
				i := i + 1
			end
		end

	index_of (c: CHARACTER_8; start_index: INTEGER): INTEGER
			-- Position of first occurrence of `c' at or after `start_index';
			-- 0 if none.
		require
			start_large_enough: start_index >= 1
			start_small_enough: start_index <= count + 1
		local
			a: like area
			i, nb, l_lower_area: INTEGER
		do
			nb := count
			if start_index <= nb then
				from
					l_lower_area := area_lower
					i := start_index - 1 + l_lower_area
					nb := nb + l_lower_area
					a := area
				until
					i = nb or else a.item (i) = c
				loop
					i := i + 1
				end
				if i < nb then
						-- We add +1 due to the area starting at 0 and not at 1
						-- and substract `area_lower'
					Result := i + 1 - l_lower_area
				end
			end
		ensure
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
		end

	item (i: INTEGER): CHARACTER_8
			-- Character at position `i'.
		do
			Result := area.item (i - 1)
		end

	last_index_of (c: CHARACTER_8; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		require
			start_index_small_enough: start_index_from_end <= count
			start_index_large_enough: start_index_from_end >= 1
		local
			a: like area
			i, l_lower_area: INTEGER
		do
			from
				l_lower_area := area_lower
				i := start_index_from_end - 1 + l_lower_area
				a := area
			until
				i < l_lower_area or else a.item (i) = c
			loop
				i := i - 1
			end
				-- We add +1 due to the area starting at 0 and not at 1.
			Result := i + 1 - l_lower_area
		ensure
			valid_result: 0 <= Result and Result <= start_index_from_end
			zero_if_absent: (Result = 0) = not substring (1, start_index_from_end).has (c)
			found_if_present: substring (1, start_index_from_end).has (c) implies item (Result) = c
			none_after: substring (1, start_index_from_end).has (c) implies
				not substring (Result + 1, start_index_from_end).has (c)
		end

feature -- Measurement

	capacity: INTEGER
			-- Allocated space
		do
			Result := area.count - 1
		end

	count: INTEGER
			-- Actual number of characters making up the string
		deferred
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

feature -- Resizing

	adapt_size
			-- Adapt the size to accommodate `count' characters.
		do
			resize (count)
		end

	grow (newsize: INTEGER)
			-- Ensure that the capacity is at least `newsize'.
		do
			if newsize > capacity then
				resize (newsize)
			end
		end

	resize (newsize: INTEGER)
			-- Rearrange string so that it can accommodate
			-- at least `newsize' characters.
		do
			area := area.aliased_resized_area_with_default ('%U', newsize + 1)
		end

	trim
			-- <Precursor>
		local
			n: like count
		do
			n := count
			if n < capacity then
				area := area.aliased_resized_area (n + 1)
			end
		ensure then
			same_string: same_string (old twin)
		end

feature -- Contract support

	is_ascii_string_8 (str: READABLE_STRING_8): BOOLEAN
		do
			Result := cursor_8 (str).all_ascii
		end

feature -- Conversion

	string: EL_STRING_8
		do
			create Result.make_from_zstring (Current)
		end

	substring (start_index, end_index: INTEGER): like string
		do
			Result := string.substring (start_index, end_index)
		end

feature -- Comparison

	same_characters (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		require
			valid_start_pos: other.valid_index (start_pos)
			valid_end_pos: other.valid_index (end_pos)
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
			valid_index_pos: valid_index (index_pos)
		local
			nb: INTEGER
		do
			nb := end_pos - start_pos + 1
			if nb <= count - index_pos + 1 then
				Result := area.same_items (other.area, other.area_lower + start_pos - 1, area_lower + index_pos - 1, nb)
			end
		ensure
			same_characters:
				attached substring (index_pos, index_pos + end_pos - start_pos) as current_substring
					and then Result = current_substring.same_string (other.substring (start_pos, end_pos))
		end

	same_string (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION): BOOLEAN
			-- Do `Current' and `other' have same character sequence?
		require
			other_not_void: other /= Void
		local
			nb: INTEGER
		do
			if other = Current then
				Result := True
			else
				nb := count
				if nb = other.count then
					Result := nb = 0 or else same_characters (other, 1, nb, 1)
				end
			end
		ensure
			definition: Result = (string ~ other.string)
		end

feature {NONE} -- Element change

	fill_character (c: CHARACTER_8)
			-- Fill with `capacity' characters all equal to `c'.
		local
			l_cap: like capacity
		do
			l_cap := capacity
			if l_cap /= 0 then
				area.fill_with (c, 0, l_cap - 1)
				set_count (l_cap)
			end
		ensure
			filled: count = capacity
			same_size: capacity = old capacity
			-- all_char: For every `i' in 1..`capacity', `item' (`i') = `c'
		end

	insert_string (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; i: INTEGER)
			-- Insert `s' at index `i', shifting characters between ranks
			-- `i' and `count' rightwards.
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		local
			pos, new_size, s_count: INTEGER; l_area: like area
		do
				-- Insert `s' if `s' is not empty, otherwise is useless.
			s_count := s.count
			if s_count /= 0 then
					-- Resize Current if necessary.
				new_size := s_count + count
				if new_size > capacity then
					resize (new_size + additional_space)
				end
					-- Perform all operations using a zero based arrays.
				l_area := area; pos := i - 1

					-- First shift from `s.count' position all characters starting at index `pos'.
				l_area.overlapping_move (pos, pos + s_count, count - pos)

					-- Copy string `s' at index `pos'.
				l_area.copy_data (s.area, s.area_lower, pos, s_count)

				set_count (new_size)
			end
		ensure
			inserted: elks_checking implies (string ~ (old substring (1, i - 1) + old (s.string) + old substring (i, count)))
		end

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		do
			if n < count then
				set_count (n)
			end
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			nb: like count
		do
			nb := count
			if n < nb then
				area.overlapping_move (nb - n, 0, n)
				set_count (n)
			end
		end

feature {NONE} -- Implementation

	share (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			area := other.area
			set_count (other.count)
		ensure
			shared_count: other.count = count
			shared_area: other.area = area
		end

feature -- Removal

	remove (i: INTEGER)
			-- Remove `i'-th character.
		local
			l_count: INTEGER
		do
			l_count := count
				-- Shift characters to the left.
			area.overlapping_move (i, i - 1, l_count - i)
				-- Update content.
			set_count (l_count - 1)
		end

	wipe_out
			-- Remove all characters.
		do
			set_count (0)
		ensure then
			is_empty: count = 0
			same_capacity: capacity = old capacity
		end

feature {EL_ZSTRING_CHARACTER_8_IMPLEMENTATION, EL_STRING_8_IMPLEMENTATION} -- Implementation

	area_lower: INTEGER
			-- Minimum index
		do
		ensure
			area_lower_non_negative: Result >= 0
			area_lower_valid: Result <= area.upper
		end

	area_upper: INTEGER
			-- Maximum index
		do
			Result := area_lower + count - 1
		ensure
			area_upper_valid: Result <= area.upper
			area_upper_in_bound: area_lower <= Result + 1
		end

	copy_area (old_area: like area; other: like Current)
		do
			if old_area = Void or else old_area = other.area or else old_area.count <= count then
					-- Prevent copying of large `area' if only a few characters are actually used.
				area := area.resized_area (count + 1)
			else
				old_area.copy_data (area, 0, 0, count)
				area := old_area
			end
		end

	current_string_8: EL_STRING_8
		do
			Result := String_8.injected (Current, 0)
		end

	order_comparison (this, other: like area; this_index, other_index, n: INTEGER): INTEGER
			-- Compare `n' characters from `this' starting at `this_index' with
			-- `n' characters from and `other' starting at `other_index'.
			-- 0 if equal, < 0 if `this' < `other',
			-- > 0 if `this' > `other'
		require
			this_not_void: this /= Void
			other_not_void: other /= Void
			n_non_negative: n >= 0
			n_valid: n <= (this.upper - this_index + 1) and n <= (other.upper - other_index + 1)
		local
			i, j, nb: INTEGER; c, c_other: CHARACTER
		do
			from
				i := this_index
				nb := i + n
				j := other_index
			until
				i = nb
			loop
				c := this [i]; c_other := other [j]
				if c /= c_other then
					Result := c |-| c_other
					i := nb - 1 -- Jump out of loop
				end
				i := i + 1
				j := j + 1
			end
		end

	set_from_ascii (str: READABLE_STRING_8)
		require
			is_7_bit: is_ascii_string_8 (str)
		local
			s: STRING_8
		do
			create s.make_from_string (str)
			area := s.area
			set_count (str.count)
		end

	set_from_string_8 (str: EL_STRING_8)
		do
			area := str.area; set_count (str.count)
		end

feature {NONE} -- Deferred

	additional_space: INTEGER
		deferred
		end

	elks_checking: BOOLEAN
		deferred
		end

	reset_hash
		deferred
		end

	set_count (number: INTEGER)
		deferred
		end

feature -- Constants

	String_8: EL_STRING_8_IMPLEMENTATION
		once
			create Result.make
		end

end