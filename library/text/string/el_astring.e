note
	description: "[
		A latin encoded string augmented by a set of unicode foreign characters
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 15:12:06 GMT (Sunday 28th July 2013)"
	revision: "4"

class
	EL_ASTRING

inherit
	STRING
		rename
			String_searcher as String_8_searcher,
			split as unicode_split,
			make_from_string as make_from_other,
			as_string_8 as parent_as_string_8,
			to_string_8 as parent_to_string_8
		export
			{EL_ASTRING, EL_ASTRING_SEARCHER} area_lower
			{NONE} parent_as_string_8, parent_to_string_8, make_from_c
		redefine
			make_from_other, make,
			append, prepend, append_string_general,
			as_string_32, to_string_32, share, out, copy, code,
			to_lower, to_upper,
			substring, substring_index, hash_code,
			wipe_out, to_lower_area, to_upper_area,
			keep_head, keep_tail, left_adjust, right_adjust,
			is_equal, is_less, valid_code, same_string,
			unicode_split
		end

	EL_EXTRA_UNICODE_CHARACTERS
		rename
			make_empty as foreign_make_empty,
			make_from_other as foreign_make_from_other,
			make as foreign_make,
			to_string_32 as foreign_string_32,
			index_of as foreign_index_of,
			capacity as foreign_capacity,
			count as foreign_count,
			is_empty as is_foreign_empty,
			is_over_extended as has_unencoded_characters,
			area as foreign_characters,
			extend as foreign_extend,
			wipe_out as foreign_wipe_out,
			to_upper as foreign_to_upper,
			to_lower as foreign_to_lower,
			has_characters as has_foreign_characters,
			Default_area as Default_foreign_characters,
			set_from_area as set_foreign_characters,
			copy_from_other as copy_foreign_characters_from_other
		export
			{NONE} all
			{ANY} upper_place_holder, foreign_string_32, has_foreign_characters, has_unencoded_characters
			{STRING_HANDLER} foreign_characters, foreign_count, set_foreign_characters
			{EL_ASTRING} foreign_wipe_out, is_place_holder_item, original_unicode, copy_foreign_characters_from_other
		undefine
			is_equal, copy, out
		end

	EL_SHARED_CODEC
		export
			{NONE} all
		undefine
			is_equal, copy, out
		end

	EL_MODULE_UTF
		export
			{NONE} all
		undefine
			is_equal, copy, out
		end

create
	make, make_empty, make_from_string, make_from_unicode, make_from_latin1, make_from_utf8, make_shared,
	make_from_other, make_filled, make_from_string_view, make_from_components, make_from_latin1_c

convert
	make_from_unicode ({STRING_32}), make_from_latin1 ({STRING_8}), make_from_string_view ({EL_STRING_VIEW}),

	to_unicode: {STRING_32}

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			Precursor (n)
			foreign_make_empty
		end

	make_from_latin1_c (latin1_ptr: POINTER)
		do
			make_from_latin1 (create {STRING}.make_from_c (latin1_ptr))
		end

	make_from_string (s: STRING)
			-- initialize with string with same encoding as codec
		do
			foreign_make_empty
			area := s.area
			count := s.count
			internal_hash_code := 0
			if Current /= s then
				create area.make_empty (count + 1)
				area.copy_data (s.area, s.area_lower, 0, count + 1)
			end
		end

	make_from_other (other: EL_ASTRING)
		do
			make_from_string (other)
			foreign_make_from_other (other)
		end

	make_from_unicode (a_unicode: READABLE_STRING_GENERAL)
			-- Initialize from the characters of `s'.
		do
			make_filled ('%/000/', a_unicode.count)
			encode (a_unicode, 0)
		ensure
			unicode_place_holders_normalized: is_normalized
		end

	make_from_latin1 (latin1: READABLE_STRING_8)
			-- Initialize from the characters of `s'.
		do
			make_filled ('%/000/', latin1.count)
			encode (latin1, 0)
		end

	make_from_utf8 (utf8: READABLE_STRING_8)
			-- Initialize from the characters of `s'.
		local
			l_unicode: STRING_32
		do
			l_unicode := UTF.utf_8_string_8_to_string_32 (utf8)
			make_from_unicode (l_unicode)
		end

	make_from_string_view (matched_text: EL_STRING_VIEW)
		local
			view_str: READABLE_STRING_GENERAL
		do
			view_str := matched_text.view_general
			if attached {EL_ASTRING} view_str as el_str then
				share (el_str)
			else
				make_from_unicode (view_str)
			end
		end

	make_from_components (s: STRING; a_foreign_characters: STRING_32)
		local
			l_foreign_count: INTEGER
		do
			make (s.count)
			append (s)
			l_foreign_count := a_foreign_characters.count
			if l_foreign_count > 0 then
				create foreign_characters.make_filled ('%U', l_foreign_count)
				foreign_characters.copy_data (a_foreign_characters.area, 0, 0, l_foreign_count)
			end
		end

	make_shared (other: like Current)
		do
			share (other)
		end

feature -- Access

	unicode_item (i: INTEGER): CHARACTER_32
		do
			Result := unicode (i).to_character_32
		end

	code (i: INTEGER): NATURAL_32
			-- substitute foreign characters (needed for string search to work)
		local
			c: CHARACTER
		do
			c := area [i-1]
			if is_place_holder_item (c) then
				Result := original_unicode (c)
			else
				Result := c.natural_32_code
			end
		end

	unicode (i: INTEGER): NATURAL_32
			-- substitute foreign characters
		local
			c: CHARACTER
		do
			c := area [i-1]
			if is_place_holder_item (c) then
				Result := original_unicode (c)
			else
				Result := codec.as_unicode (c).natural_32_code
			end
		end

	hash_code: INTEGER
			-- Hash code value
		require else
			place_holders_normalized: is_normalized
		local
			i, nb: INTEGER
			l_area: like area
		do
			Result := internal_hash_code
			if Result = 0 then
				l_area := area
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
				from i := 1; nb := count until i > nb loop
					Result := ((Result \\ 8388593) |<< 8) + l_area.item (i - 1).code
					i := i + 1
				end
				internal_hash_code := Result
			end
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
			-- <Precursor>
		local
			l_other: EL_ASTRING
		do
			if attached {EL_ASTRING} other as astr then
				l_other := astr
			else
				create l_other.make_from_unicode (other)
			end
			if has_foreign_characters or l_other.has_foreign_characters then
				Result := string_searcher.substring_index (Current, l_other, start_index, count)
			else
				Result := Precursor (l_other, start_index)
			end
		end

	index_of_unicode (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			c := codec.as_latin (uc)
			if c = '%U' then
				c := place_holder (uc)
				if c = '%U' then
					Result := 0
				else
					Result := character_32_index_of (uc, start_index)
				end
			else
				Result := index_of (c, start_index)
			end
		end

feature -- Element change

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
				nb_space > nb or else not is_space_character (l_area.item (nb_space))
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
				internal_hash_code := 0
			end
			normalize_place_holders
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	right_adjust
			-- Remove trailing whitespace.
		local
			i, nb: INTEGER
			nb_space: INTEGER
			l_area: like area
		do
			if has_foreign_characters then
					-- Compute number of spaces at the right of current string.
				from
					nb := count - 1
					i := nb
					l_area := area
				until
					i < 0 or else not is_space_character (l_area.item (i))
				loop
					nb_space := nb_space + 1
					i := i - 1
				end

				if nb_space > 0 then
						-- Set new count.
					count := nb + 1 - nb_space
					internal_hash_code := 0
				end
				normalize_place_holders
			else
				Precursor
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	set_from_unicode (s: READABLE_STRING_GENERAL)
			-- Initialize from the characters of `s'.
		do
			grow (s.count)
			foreign_make_empty
			set_count (s.count)
			encode (s, 0)
		end

	share (other: like Current)
		do
			Precursor (other)
			foreign_characters := other.foreign_characters
		end

	append (s: READABLE_STRING_8)
		local
			old_count: INTEGER
		do
			if attached {EL_ASTRING} s as l_as then
				if l_as.has_foreign_characters then
					old_count := count
					Precursor (l_as) -- Append as STRING_8
					if has_foreign_characters then
						-- Normalize place holders
						codec.update_foreign_characters (area, s.count, old_count, l_as, Current, False)
					else
						copy_foreign_characters_from_other (l_as)
					end
				else
					Precursor (l_as)
				end
			else
				append (create {EL_ASTRING}.make_from_latin1 (s))
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	append_string_general (s: READABLE_STRING_GENERAL)
		do
			if attached {READABLE_STRING_8} s as l_s8 then
				append (l_s8)
			else
				append_unicode_general (s)
			end
		end

	append_unicode_general (s: READABLE_STRING_GENERAL)
		local
			old_count: INTEGER
		do
			old_count := count
			grow (old_count + s.count)
			set_count (old_count + s.count)
			encode (s, old_count)
			internal_hash_code := 0
			-- we don't need to call normalize_place_holders
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	prepend (s: READABLE_STRING_8)
		local
			old_count: INTEGER
			l_foreign_characters: EL_EXTRA_UNICODE_CHARACTERS
		do
			if attached {like Current} s as l_as then
				if l_as.has_foreign_characters then
					old_count := count
					precursor (l_as)
					create l_foreign_characters.make_from_other (Current)
					copy_foreign_characters_from_other (l_as)
					codec.update_foreign_characters (area, old_count, l_as.count, l_foreign_characters, Current, False)
				else
					Precursor (l_as)
				end
			else
				Precursor (s)
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		local
			place_holders_removed: BOOLEAN
		do
			if has_foreign_characters then
				place_holders_removed := substring_has_place_holders (n + 1, count)
				Precursor (n)
				if place_holders_removed then
					normalize_place_holders
				end
			else
				Precursor (n)
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			place_holders_removed: BOOLEAN
		do
			if has_foreign_characters then
				place_holders_removed := substring_has_place_holders (1, count - n)
				Precursor (n)
				if place_holders_removed then
					normalize_place_holders
				end
			else
				Precursor (n)
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	translate (originals, substitutions: like Current)
			-- translate characters occurring in 'originals' with substitute
			-- ommiting any characters that have a NUL substition character '%/000/'
		require
			same_lengths: originals.count = substitutions.count
		local
			l_translated: like Current
		do
			l_translated := translated (originals, substitutions)
			area := l_translated.area
			set_count (l_translated.count)
			foreign_characters := l_translated.foreign_characters
			normalize_place_holders
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	append_unicode (c: like code)
			-- Append `c' at end.
			-- It would be nice to make this routine over ride 'append_code' but unfortunately
			-- the post condition links it to 'code' and for performance reasons it is undesirable to have
			-- code return unicode.
		local
			current_count: INTEGER
		do
			current_count := count + 1
			if current_count > capacity then
				resize (current_count)
			end
			set_count (current_count)
			put_unicode (c, current_count)
		ensure then
			item_inserted: unicode (count) = c
			new_count: count = old count + 1
			stable_before: elks_checking implies substring (1, count - 1) ~ (old twin)
		end

	put_unicode (v: like code; i: INTEGER)
			-- put unicode at i th position
		require -- from STRING_GENERAL
			valid_index: valid_index (i)
		do
			codec.encode_character (v.to_character_32, area, i - 1, Current)
			if has_foreign_characters and then i < count and then substring_has_place_holders (i + 1, count) then
				normalize_place_holders
			end
		ensure
			inserted: unicode (i) = v
			stable_count: count = old count
			stable_before_i: Elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: Elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
			unicode_place_holders_normalized: is_normalized
		end

	escape (unicode_characters: READABLE_STRING_GENERAL; escape_character: CHARACTER_32)
		local
			l_area: SPECIAL [CHARACTER_32]
			c: CHARACTER_32
			l_escaped: STRING_32
			i, l_count: INTEGER
		do
			l_count := count
			l_area := to_unicode.area
			create l_escaped.make (count)
			from i := 0 until i = l_count loop
				c := l_area [i]
				if unicode_characters.has (c) then
					l_escaped.append_character (escape_character)
				end
				l_escaped.append_character (c)
				i := i + 1
			end
			if l_escaped.count > count then
				make_from_unicode (l_escaped)
			end
		end

feature -- Status query

	is_alpha_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if is_place_holder_item (c) then
				Result := original_character (c).is_alpha
			else
				Result := codec.is_alpha (c.natural_32_code)
			end
		end

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if is_place_holder_item (c) then
				Result := original_character (c).is_alpha_numeric
			else
				Result := codec.is_alpha_numeric (c.natural_32_code)
			end
		end

	is_normalized: BOOLEAN
			-- True if place holders for extra unicode characters are in normalized form
			-- Going from left to right and ignoring repeats, each new place holder assumes the nextest highest
			-- value in the combined sequence {1..8, 14..31}
		local
			i: INTEGER
			c, previous_place_holder: CHARACTER
			l_area: like area
		do
			l_area := area
			if has_foreign_characters then
				Result := True
				from i := 0 until not Result or i = count loop
					c := l_area [i]
					if is_place_holder_item (c) and then c > previous_place_holder then
						inspect c
							when '%/1/'..'%/8/', '%/15/'..'%/31/' then
								Result := c = previous_place_holder.next
							when '%/14/' then
								Result := previous_place_holder = '%/8/'
						else
							Result := False
						end
						previous_place_holder := c
					end
					i := i + 1
				end
				if Result and then previous_place_holder /= upper_place_holder then
					Result := False
				end
			else
				Result := True
			end
		end

	valid_code (v: NATURAL_32): BOOLEAN
			-- Is `v' a valid code for a CHARACTER_32?
		do
			Result := True
		end

	same_string (other: READABLE_STRING_8): BOOLEAN
			-- Do `Current' and `other' have same character sequence?
		do
			if other = Current then
				Result := True
			elseif attached {like Current} other as l_other then
				Result := same_items_as_other (l_other, count)
			else
				Result := same_items_as_other (create {like Current}.make_from_unicode (other), count)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			l_count: INTEGER
			l_hash, l_other_hash: like internal_hash_code
		do
			if other = Current then
				Result := True
			else
				l_count := count
				if l_count = other.count then
						-- Let's compare the content if and only if the hash_code are the same or not yet computed.
					l_hash := internal_hash_code
					l_other_hash := other.internal_hash_code
					if l_hash = 0 or else l_other_hash = 0 or else l_hash = l_other_hash then
						Result := same_items_as_other (other, l_count)
					end
				end
			end
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is string lexicographically lower than `other'?
		local
			other_count: INTEGER
			current_count: INTEGER
		do
			if has_foreign_characters or else other.has_foreign_characters then
				if other /= Current then
					other_count := other.count
					current_count := count
					if other_count = current_count then
						Result := str_strict_compare (area, other.area_lower, area_lower, other_count, other) > 0
					else
						if current_count < other_count then
							Result := str_strict_compare (area, other.area_lower, area_lower, current_count, other) >= 0
						else
							Result := str_strict_compare (area, other.area_lower, area_lower, other_count, other) > 0
						end
					end
				end
			else
				Result := Precursor (other)
			end
		end

feature -- Output

	out: STRING
			-- Printable representation
		local
			l_area: like area
			i: INTEGER
			c: CHARACTER
		do
			if has_foreign_characters then
				create Result.make (count + foreign_characters.count * 5 + foreign_characters.count + 3)
				l_area := Result.area
				from i := 0 until i = count loop
					c := l_area [i]
					if is_place_holder_item (c) then
						Result.append ("%%/")
						Result.append_natural_32 (c.natural_32_code)
						Result.append_character ('/')
					else
						Result.append_character (c)
					end
					i := i + 1
					Result.append (" {")
					UTF.string_32_into_utf_8_string_8 (foreign_string_32, Result)
					Result.append_character ('}')
				end
			else
				Result := Precursor {STRING_8}
			end
		end

feature -- Conversion

	to_latin1: STRING
			-- coded as ISO-8859-1
		do
			Result := to_latin1_32.to_string_8
		end

	to_utf8: STRING
		do
			Result := UTF.string_32_to_utf_8_string_8 (to_unicode)
		end

	as_string_32, to_string_32, to_latin1_32, to_unicode: STRING_32
			-- UCS-4
		do
			create Result.make_filled ('%/000/', count)
			codec.decode (count, area, Result.area, Current)
		end

	as_string_8, to_string_8: STRING_8
		require
			no_foreign_characters: not has_foreign_characters
		do
			create Result.make_from_string (Current)
		end

	to_lower
			-- Convert to lower case.
		do
			to_lower_area (area, 0, count - 1)
			if has_foreign_characters then
				foreign_to_lower
			end
			internal_hash_code := 0
		end

	to_upper
			-- Convert to upper case.
		do
			to_upper_area (area, 0, count - 1)
			if has_foreign_characters then
				foreign_to_upper
			end
			internal_hash_code := 0
		end

	to_proper_case
		local
			i: INTEGER
			state_alpha: BOOLEAN
		do
			to_lower
			from i := 1 until i > count loop
				if state_alpha then
					if not is_alpha_item (i) then
						state_alpha := False
					end
				else
					if is_alpha_item (i) then
						state_alpha := True
						to_upper_area (area, i - 1, i - 1)
					end
				end
				i := i + 1
			end
		ensure
			unicode_place_holders_normalized: is_normalized
		end

	as_proper_case: EL_ASTRING
		do
			Result := twin
			Result.to_proper_case
		end

	translated (originals, substitutions: like Current): like Current
			-- translate characters occurring in 'originals' with 'substitutions' character at same index,
			-- and deleting characters that have a NUL substition character '%U'
		require
			same_lengths: originals.count = substitutions.count
		local
			i, d, index: INTEGER
			substitution: like item
			l_area, l_result_area: like area
		do
			create Result.make (count)
			l_area := area
			l_result_area := Result.area
			from i := 0; d := 0 until i = count loop
				index := originals.index_of (l_area.item (i), 1)
				if index > 0 then
					substitution := substitutions [index]
					if substitution /= '%U' then
						l_result_area.put (substitution, d)
						d := d + 1
					end
				else
					l_result_area.put (l_area.item (i), d)
					d := d + 1
				end
				i := i + 1
			end
			l_result_area.put ('%U', d)
			Result.set_count (d)
			if has_foreign_characters then
				Result.set_foreign_characters (foreign_characters)
				Result.normalize_place_holders
			end
		end

	escaped (unicode_characters: READABLE_STRING_GENERAL; escape_character: CHARACTER_32): like Current
		do
			create Result.make_from_other (Current)
			Result.escape (unicode_characters, escape_character)
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		do
			if (1 <= start_index) and (start_index <= end_index) and (end_index <= count) then
				Result := new_string (end_index - start_index + 1)
				Result.area.copy_data (area, start_index - 1, 0, end_index - start_index + 1)
				Result.set_count (end_index - start_index + 1)
			else
				Result := new_string (0)
			end
			if has_foreign_characters then
				Result.set_foreign_characters (codec.updated_foreign_characters (Result.area, Result.count, Current))
			end
		ensure then
			unicode_place_holders_normalized: Result.is_normalized
		end

feature -- Conversion

	unicode_split (a_unicode_separator: CHARACTER_32): LIST [like Current]
		local
			l_separator: CHARACTER
		do
			l_separator := codec.as_latin (a_unicode_separator)
			if l_separator = '%U' then
				l_separator := place_holder (a_unicode_separator)
				if l_separator = '%U' then
					create {ARRAYED_LIST [like Current]} Result.make_from_array (<< twin >>)
				else
					Result := Precursor (a_unicode_separator)
						-- To satisfy '{READABLE_STRING_8}.index_of' post condition 'none_before'
						-- but we don't really need to
				end
			else
				Result := split (l_separator)
			end
		end

	split (a_separator: CHARACTER): LIST [like Current]
			-- Split on `a_separator'.
		local
			l_list: ARRAYED_LIST [like Current]
			part: like Current
			i, j, c: INTEGER
		do
			c := count
				-- Worse case allocation: every character is a separator
			create l_list.make (occurrences (a_separator) + 1)
			if c > 0 then
				from
					i := 1
				until
					i > c
				loop
					j := index_of (a_separator, i)
					if j = 0 then
							-- No separator was found, we will
							-- simply create a list with a copy of
							-- Current in it.
						j := c + 1
					end
					part := substring (i, j - 1)
					l_list.extend (part)
					i := j + 1
				end
				if j = c then
					check
						last_character_is_a_separator: item (j) = a_separator
					end
						-- A separator was found at the end of the string
					l_list.extend (new_string (0))
				end
			else
					-- Extend empty string, since Current is empty.
				l_list.extend (new_string (0))
			end
			Result := l_list
			check
				l_list.count = occurrences (a_separator) + 1
			end
		ensure
			Result /= Void
		end

	copy (other: like Current)
		do
			if other /= Current then
				Precursor {STRING_8} (other)
				if other.has_foreign_characters then
					foreign_characters := other.foreign_characters.twin
				end
			end
		end

feature {STRING_HANDLER, EL_ASTRING_SEARCHER} -- Implementation

	String_searcher: EL_ASTRING_SEARCHER
			-- String searcher specialized for READABLE_STRING_8 instances
		once
			create Result.make
		end

	str_strict_compare (this: like area; this_index, other_index, n: INTEGER; other: like Current): INTEGER
			-- Compare `n' characters from `this' starting at `this_index' with
			-- `n' characters from and `other' starting at `other_index'.
			-- 0 if equal, < 0 if `this' < `other',
			-- > 0 if `this' > `other'
		require
			this_not_void: this /= Void
			other_not_void: other /= Void
			n_non_negative: n >= 0
			n_valid: n <= (this.upper - this_index + 1) and n <= (other.area.upper - other_index + 1)
		local
			i, j, nb: INTEGER
			l_current_code, l_other_code: NATURAL
			other_area: like area
			place_holder_upper, other_place_holder_upper, l_current_char, l_other_char: CHARACTER
			is_current_a_place_holder, is_other_a_place_holder: BOOLEAN
		do
			other_area := other.area
			place_holder_upper := upper_place_holder
			other_place_holder_upper := other.upper_place_holder
			from
				i := this_index
				nb := i + n
				j := other_index
			until
				i = nb
			loop
				l_current_char := this [i]
				is_current_a_place_holder := l_current_char <= place_holder_upper and then is_place_holder_item (l_current_char)
				l_other_char := other_area [i]
				is_other_a_place_holder := l_other_char <= other_place_holder_upper and then other.is_place_holder_item (l_other_char)

				-- Compare like with like
				if is_current_a_place_holder or is_other_a_place_holder then
					l_current_code := unicode (i + 1)
					l_other_code := other.unicode (i + 1)
				else
					l_current_code := l_current_char.natural_32_code
					l_other_code := l_other_char.natural_32_code
				end

				if l_current_code /= l_other_code then
					if l_current_code < l_other_code then
						Result := (l_other_code - l_current_code).to_integer_32
					else
						Result := -(l_current_code - l_other_code).to_integer_32
					end
					i := nb - 1 -- Jump out of loop
				end
				i := i + 1
				j := j + 1
			end
		end

	encode (s: READABLE_STRING_GENERAL; area_offset: INTEGER)
		require
			valid_area_offset: s.count > 0 implies area.valid_index (s.count + area_offset - 1)
		do
			codec.encode (s, area, area_offset, Current)
		end

	normalize_place_holders
			-- normalize order of place holders for foreign characters and their number
			-- Going from left to right and ignoring repeats, each new place holder is 1 greater than previous.
			-- The last new place holder must equal upper_place_holder
			-- Strings initialized from the unicode are already normalized
		do
			if has_foreign_characters then
				set_foreign_characters (codec.updated_foreign_characters (area, count, Current))
			end
		end

	substring_has_place_holders (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := has_place_holders (upper_place_holder, start_index, end_index)
		end

	has_place_holders (place_holder_upper: CHARACTER; start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER
			l_area: like area
			c: CHARACTER
		do
			if place_holder_upper > '%U' then
				l_area := area
				from i := start_index - 1 until Result or i = end_index loop
					c := l_area [i]
					Result := c <= place_holder_upper and then (c < '%T' or c > '%R')
					i := i + 1
				end
			end
		end

	to_lower_area (a: like area; start_index, end_index: INTEGER)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			codec.lower_case (a, start_index, end_index, Current)
		end

	to_upper_area (a: like area; start_index, end_index: INTEGER)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their upper version when available.
		do
			codec.upper_case (a, start_index, end_index, Current)
		end

	same_items_as_other (other: like Current; a_count: INTEGER): BOOLEAN
		do
			Result := area.same_items (other.area, other.area_lower, area_lower, a_count)
							and then foreign_characters ~ other.foreign_characters
		end

feature -- Removal

	wipe_out
			-- Remove all characters.
		do
			Precursor
			foreign_make_empty
		end

end
