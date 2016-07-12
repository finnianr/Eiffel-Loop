note
	description: "Summary description for {EL_ZSTRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-27 11:01:12 GMT (Sunday 27th December 2015)"
	revision: "5"

deferred class
	EL_ZSTRING_IMPLEMENTATION

inherit
	STRING_HANDLER

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			count := 0
			reset_hash
			create area.make_filled ('%/000/', n + 1)
		end

	make_from_string (s: STRING)
			-- initialize with string that has the same encoding as codec
		do
			area := s.area; count := s.count
			reset_hash
			create area.make_empty (count + 1)
			area.copy_data (s.area, 0, 0, count)
			area.extend ('%U')
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

	occurrences (c: CHARACTER_8): INTEGER
			-- Number of times `c' appears in the string
		local
			i, nb: INTEGER
			a: SPECIAL [CHARACTER_8]
		do
			from
				i := area_lower
				nb := count + i
				a := area
			until
				i = nb
			loop
				if a.item (i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		ensure
			zero_if_empty: count = 0 implies Result = 0
		end

feature -- Status query

	ends_with (s: EL_ZSTRING_IMPLEMENTATION): BOOLEAN
			-- Does string finish with `s'?
		require
			argument_not_void: s /= Void
		local
			i, j, nb: INTEGER
			l_area, l_s_area: like area
		do
			if Current = s then
				Result := True
			else
				i := s.count
				j := count
				if i <= j then
					from
						l_area := area
						l_s_area := s.area
						j := area_upper + 1
						i := s.area_upper + 1
						nb := s.area_lower
						Result := True
					until
						i = nb
					loop
						i := i - 1
						j := j - 1
						if l_area.item (j) /= l_s_area.item (i) then
							Result := False
							i := nb -- Jump out of loop
						end
					end
				end
			end
		ensure
			definition: Result = s.string.same_string (substring (count - s.count + 1, count))
		end

	has (c: CHARACTER_8): BOOLEAN
			-- Does string include `c'?
		local
			i, nb: INTEGER
			l_area: like area
		do
			nb := count
			if nb > 0 then
				from
					i := area_lower
					l_area := area
					nb := nb + i
				until
					i = nb or else (l_area.item (i) = c)
				loop
					i := i + 1
				end
				Result := (i < nb)
			end
		ensure then
			false_if_empty: count = 0 implies not Result
			true_if_first: count > 0 and then item (1) = c implies Result
		end

	is_boolean: BOOLEAN
			-- Does `Current' represent a BOOLEAN?
		do
			Result := current_string.is_boolean
		end

	is_double, is_real_64: BOOLEAN
		do
			Result := current_string.is_double
		end

	is_integer, is_integer_32: BOOLEAN
		do
			Result := current_string.is_integer
		end

	starts_with (s: EL_ZSTRING_IMPLEMENTATION): BOOLEAN
			-- Does string begin with `s'?
		require
			argument_not_void: s /= Void
		local
			i, j, nb: INTEGER
			l_area, l_s_area: like area
		do
			if Current = s then
				Result := True
			else
				i := s.count
				if i <= count then
					from
						l_area := area
						l_s_area := s.area
						j := area_lower + i
						i := s.area_upper + 1
						nb := s.area_lower
						Result := True
					until
						i = nb
					loop
						i := i - 1
						j := j - 1
						if l_area.item (j) /= l_s_area.item (i) then
							Result := False
							i := nb -- Jump out of loop
						end
					end
				end
			end
		ensure
			definition: Result = s.string.same_string (substring (1, s.count))
		end

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
			area := area.aliased_resized_area_with_default ('%/000/', newsize + 1)
		end

	trim
			-- <Precursor>
		local
			n: like count
		do
			n := count
			if n < capacity then
				area := area.aliased_resized_area (n)
			end
		ensure then
			same_string: same_string (old twin)
		end

feature -- Comparison

 	same_characters (other: EL_ZSTRING_IMPLEMENTATION; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		require
			other_not_void: other /= Void
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
			same_characters: Result = substring (index_pos, index_pos + end_pos - start_pos).same_string (other.substring (start_pos, end_pos))
		end

	same_string (other: EL_ZSTRING_IMPLEMENTATION): BOOLEAN
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

feature -- Conversion

	linear_representation: LINEAR [CHARACTER_8]
			-- Representation as a linear structure
		do
			Result := string.linear_representation
		end

	string: EL_ZSTRING_8_IMP
		do
			create Result.make_from_zstring (Current)
		end

	substring (start_index, end_index: INTEGER): like string
		do
			Result := string.substring (start_index, end_index)
		end

	to_boolean: BOOLEAN
		do
			Result := current_string.to_boolean
		end

	to_double, to_real_64: DOUBLE
		do
			Result := current_string.to_double
		end

	to_integer, to_integer_32: INTEGER_32
		do
			Result := current_string.to_integer
		end

feature -- Element change

	append (s: EL_ZSTRING_IMPLEMENTATION)
			-- Append characters of `s' at end.
		require
			argument_not_void: s /= Void
		local
			l_count, s_count, l_new_size: INTEGER
		do
			s_count := s.count
			if s_count > 0 then
				l_count := count
				l_new_size := s_count + l_count
				if l_new_size > capacity then
					resize (l_new_size + additional_space)
				end
				area.copy_data (s.area, s.area_lower, l_count, s_count)
				count := l_new_size
				reset_hash
			end
		ensure
			new_count: count = old count + old s.count
			appended: elks_checking implies string.same_string (old (string + s.string))
		end

	append_substring (s: EL_ZSTRING_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			argument_not_void: s /= Void
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			l_count, l_s_count, l_new_size: INTEGER
		do
			l_s_count := end_index - start_index + 1
			if l_s_count > 0 then
				l_count := count
				l_new_size := l_s_count + l_count
				if l_new_size > capacity then
					resize (l_new_size + additional_space)
				end
				area.copy_data (s.area, s.area_lower + start_index - 1, l_count, l_s_count)
				count := l_new_size
				reset_hash
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies string.same_string (old (string + s.substring (start_index, end_index)))
		end

	fill_character (c: CHARACTER_8)
			-- Fill with `capacity' characters all equal to `c'.
		local
			l_cap: like capacity
		do
			l_cap := capacity
			if l_cap /= 0 then
				area.fill_with (c, 0, l_cap - 1)
				count := l_cap
				reset_hash
			end
		ensure
			filled: count = capacity
			same_size: capacity = old capacity
			-- all_char: For every `i' in 1..`capacity', `item' (`i') = `c'
		end

	insert_character (c: CHARACTER_8; i: INTEGER)
			-- Insert `c' at index `i', shifting characters between ranks
			-- `i' and `count' rightwards.
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		local
			pos, new_size: INTEGER
			l_area: like area
		do
				-- Resize Current if necessary.
			new_size := 1 + count
			if new_size > capacity then
				resize (new_size + additional_space)
			end

				-- Perform all operations using a zero based arrays.
			pos := i - 1
			l_area := area

				-- First shift from `s.count' position all characters starting at index `pos'.
			l_area.overlapping_move (pos, pos + 1, count - pos)

				-- Insert new character
			l_area.put (c, pos)

			count := new_size
			reset_hash
		ensure
			one_more_character: count = old count + 1
			inserted: item (i) = c
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i, count))
		end

	insert_string (s: EL_ZSTRING_IMPLEMENTATION; i: INTEGER)
			-- Insert `s' at index `i', shifting characters between ranks
			-- `i' and `count' rightwards.
		require
			string_exists: s /= Void
			valid_insertion_index: 1 <= i and i <= count + 1
		local
			pos, new_size: INTEGER
			l_s_count: INTEGER
			l_area: like area
		do
				-- Insert `s' if `s' is not empty, otherwise is useless.
			l_s_count := s.count
			if l_s_count /= 0 then
					-- Resize Current if necessary.
				new_size := l_s_count + count
				if new_size > capacity then
					resize (new_size + additional_space)
				end

					-- Perform all operations using a zero based arrays.
				l_area := area
				pos := i - 1

					-- First shift from `s.count' position all characters starting at index `pos'.
				l_area.overlapping_move (pos, pos + l_s_count, count - pos)

					-- Copy string `s' at index `pos'.
				l_area.copy_data (s.area, s.area_lower, pos, l_s_count)

				count := new_size
				reset_hash
			end
		ensure
			inserted: elks_checking implies (string ~ (old substring (1, i - 1) + old (s.string) + old substring (i, count)))
		end

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		do
			if n < count then
				count := n
				reset_hash
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
				count := n
				reset_hash
			end
		end

	left_adjust
			-- Remove leading whitespace.
		local
			nb, nb_space: INTEGER
			l_area: like area
		do
				-- Compute number of spaces at the left of current string.
			from
				nb := count - 1
				l_area := area
			until
				nb_space > nb or else not l_area.item (nb_space).is_space
			loop
				nb_space := nb_space + 1
			end

			if nb_space > 0 then
					-- Set new count value.
				nb := nb + 1 - nb_space
					-- Shift characters to the left.
				l_area.overlapping_move (nb_space, 0, nb)
					-- Set new count.
				count := nb
				reset_hash
			end
		end

	prepend (s: EL_ZSTRING_IMPLEMENTATION)
			-- Prepend characters of `s' at front.
		require
			argument_not_void: s /= Void
		do
			insert_string (s, 1)
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies string.same_string (old (s.string + string))
		end

	prepend_character (c: CHARACTER_8)
			-- Add `c' at front.
		local
			l_area: like area
		do
			if count = capacity then
				resize (count + additional_space)
			end
			l_area := area
			l_area.overlapping_move (0, 1, count)
			l_area.put (c, 0)
			count := count + 1
			reset_hash
		ensure
			new_count: count = old count + 1
		end

	prune_all (c: CHARACTER)
			-- Remove all occurrences of `c'.
		require else
			True
		local
			i, j, nb: INTEGER; l_area: like area; l_char: CHARACTER
		do
				-- Traverse string and shift characters to the left
				-- each time we find an occurrence of `c'.
			from
				l_area := area
				nb := count
			until
				i = nb
			loop
				l_char := l_area.item (i)
				if l_char /= c then
					l_area.put (l_char, j)
					j := j + 1
				end
				i := i + 1
			end
			count := j
			l_area [j] := '%U'
			reset_hash
		ensure then
			changed_count: count = (old count) - (old occurrences (c))
			-- removed: For every `i' in 1..`count', `item' (`i') /= `c'
		end

	replace_substring (s: EL_ZSTRING_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Replace characters from `start_index' to `end_index' with `s'.
		require
			string_not_void: s /= Void
			valid_start_index: 1 <= start_index
			valid_end_index: end_index <= count
			meaningfull_interval: start_index <= end_index + 1
		local
			new_size: INTEGER
			diff: INTEGER
			l_area: like area
			s_count: INTEGER
			old_count: INTEGER
		do
			s_count := s.count
			old_count := count
			diff := s_count - (end_index - start_index + 1)
			new_size := diff + old_count
			if diff > 0 then
					-- We need to resize the string.
				grow (new_size)
			end

			l_area := area
				--| We move the end of the string forward (if diff is > 0), backward (if diff < 0),
				--| and nothing otherwise.
			if diff /= 0 then
				l_area.overlapping_move (end_index, end_index + diff, old_count - end_index)
			end
				--| Set new count
			set_count (new_size)
				--| We copy the substring.
			l_area.copy_data (s.area, s.area_lower, start_index - 1, s_count)
		ensure
			new_count: count = old count + old s.count - end_index + start_index - 1
			replaced: elks_checking implies (string ~ (old (substring (1, start_index - 1) + s.string + substring (end_index + 1, count))))
		end

	replace_substring_all (original, new: READABLE_STRING_8)
		do
			current_string.replace_substring_all (original, new)
		end

	right_adjust
			-- Remove trailing whitespace.
		local
			i, nb: INTEGER
			nb_space: INTEGER
			l_area: like area
		do
				-- Compute number of spaces at the right of current string.
			from
				nb := count - 1
				i := nb
				l_area := area
			until
				i < 0 or else not l_area.item (i).is_space
			loop
				nb_space := nb_space + 1
				i := i - 1
			end

			if nb_space > 0 then
					-- Set new count.
				count := nb + 1 - nb_space
				reset_hash
			end
		end

	set_area (a_area: like area)
		do
			area := a_area
		end

	share (other: EL_ZSTRING_IMPLEMENTATION)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			area := other.area
			count := other.count
			reset_hash
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
			count := l_count - 1
			reset_hash
		end

	remove_substring (start_index, end_index: INTEGER)
			-- Remove all characters from `start_index'
			-- to `end_index' inclusive.
		require
			valid_start_index: 1 <= start_index
			valid_end_index: end_index <= count
			meaningful_interval: start_index <= end_index + 1
		local
			l_count, nb_removed: INTEGER
		do
			nb_removed := end_index - start_index + 1
			if nb_removed > 0 then
				l_count := count
				area.overlapping_move (start_index + nb_removed - 1, start_index - 1, l_count - end_index)
				count := l_count - nb_removed
				reset_hash
			end
		ensure
			removed: elks_checking implies string ~ (old substring (1, start_index - 1) + old substring (end_index + 1, count))
		end

	wipe_out
			-- Remove all characters.
		do
			count := 0
		ensure then
			is_empty: count = 0
			same_capacity: capacity = old capacity
		end

feature {STRING_HANDLER} -- Implementation

	frozen set_count (number: INTEGER)
			-- Set `count' to `number' of characters.
		do
			count := number
			reset_hash
		end

feature {EL_ZSTRING_IMPLEMENTATION} -- Implementation

	additional_space: INTEGER
		deferred
		end

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

	current_string: like Once_zstring_8_array.item
		do
			Result := Once_zstring_8_array [0]
			Result.set_from_zstring (Current)
		end

	elks_checking: BOOLEAN
		deferred
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

	reset_hash
		deferred
		end

feature -- Constants

	Once_zstring_8_array: SPECIAL [EL_ZSTRING_8_IMP]
		once
			create Result.make_empty (3)
			from  until Result.count = 3 loop
				Result.extend (create {EL_ZSTRING_8_IMP}.make_empty)
			end
		end
end
