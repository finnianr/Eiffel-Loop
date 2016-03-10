note
	description: "[
		A latin encoded string augmented by a set of unicode foreign characters.
		
		Potential problems:
			Calling set_count can break a postcondition is_normalized
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
			append as append_string_8,
			append_string as append,
			append_string_general as append_string,
			as_string_8 as parent_as_string_8,
			make_from_string as make_from_other,
			has as has_character_8,
			index_of as index_of_8,
			insert_string as insert_string_8,
			last_index_of as last_index_of_character_8,
			replace_character as obsolete_replace_character,
			replace_substring_all as replace_substring_all_8,
			precede as precede_8,
			prepend_character as prepend_character_8,
			prepend as prepend_string_8,
			prepend_string as prepend,
			prepend_string_general as prepend_string,
			prune_all as prune_all_8,
			String_searcher as String_8_searcher,
			split as unicode_split,
			starts_with as starts_with_string_8,
			starts_with_general as starts_with,
			to_string_8 as parent_to_string_8
		export
			{EL_ASTRING, EL_ASTRING_SEARCHER} area_lower, set_count
			{NONE} append_string_8, prepend_string_8, parent_as_string_8, parent_to_string_8, make_from_c, has_character_8,
				last_index_of_character_8, index_of_8, insert_string_8, replace_substring_all_8, starts_with_string_8
		redefine
			make_from_other, make,
			append, append_string, prepend, prepend_string, replace_substring, remove, remove_substring,
			as_string_32, to_string_32, share, out, copy, code,
			to_lower, to_upper,
			plus,
			substring, substring_index, hash_code,
			wipe_out, to_lower_area, to_upper_area,
			keep_head, keep_tail, left_adjust, right_adjust,
			is_equal, is_less, valid_code, same_string, starts_with,
			unicode_split
		end

	EL_EXTRA_UNICODE_CHARACTERS
		rename
			make_empty as foreign_make_empty,
			make_from_other as foreign_make_from_other,
			make as foreign_make,
			to_string_32 as foreign_string_32,
			index_of as foreign_index_of,
			item as foreign_item,
			capacity as foreign_capacity,
			count as foreign_count,
			is_empty as is_foreign_empty,
			is_over_extended as has_unencoded_characters,
			has as foreign_has,
			area as foreign_characters,
			extend as foreign_extend,
			wipe_out as foreign_wipe_out,
			to_upper as foreign_to_upper,
			to_lower as foreign_to_lower,
			has_characters as has_foreign_characters,
			Default_area as Default_foreign_characters,
			set_from_area as set_foreign_characters,
			copy_from_other as copy_foreign_characters_from_other,
			keep_head as foreign_keep_head
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
			area := s.area; count := s.count
			internal_hash_code := 0
			if Current /= s then
				make_filled ('%U', s.count)
				area.copy_data (s.area, 0, 0, s.count)
			end
		end

	make_from_other (other: EL_ASTRING)
		do
			make_from_string (other)
			foreign_make_from_other (other)
		end

	make_from_unicode (a_unicode: READABLE_STRING_GENERAL)
		do
			make_filled ('%U', a_unicode.count)
			encode (a_unicode, 0)
		ensure
			unicode_place_holders_normalized: is_normalized
		end

	make_from_latin1 (latin1: READABLE_STRING_8)
		do
			make_filled ('%/000/', latin1.count)
			encode (latin1, 0)
		end

	make_from_utf8 (utf8: READABLE_STRING_8)
		local
			l_unicode: STRING_32
		do
			l_unicode := UTF.utf_8_string_8_to_string_32 (utf8)
			make_from_unicode (l_unicode)
		end

	make_from_string_view (matched_text: EL_STRING_VIEW)
		do
			make_from_other (matched_text.to_string)
		end

	make_from_components (s: STRING; a_foreign_characters: like foreign_characters)
		do
			make_filled ('%U', s.count)
			area.copy_data (s.area, 0, 0, s.count)
			foreign_characters := a_foreign_characters
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
		do
			Result := Precursor
		end

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			if uc = '%U' then
				Result := index_of (uc.to_character_8, start_index)
			else
				c := place_holder (uc)
				if c = '%U' then
					c := codec.as_latin (uc)
				end
				if c /= '%U' then
					Result := index_of_8 (c, start_index)
				end
			end
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		local
			last_encoded_foreign_character: CHARACTER_32; c: CHARACTER_8
			l_codec: like codec
		do
			l_codec := codec
			l_codec.set_encoded_character (uc)
			last_encoded_foreign_character := l_codec.last_encoded_foreign_character
			if last_encoded_foreign_character /= '%U' and then foreign_has (last_encoded_foreign_character) then
				c := place_holder (last_encoded_foreign_character)
			else
				c := l_codec.last_encoded_character
			end
			Result := last_index_of_character_8 (c, start_index_from_end)
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		local
			l_other: EL_ASTRING
		do
			l_other := adapted_general (other)
			if l_other.has_foreign_characters then
				Result := string_searcher.substring_index (Current, l_other, start_index, count)
			else
				Result := Precursor (l_other, start_index)
			end
		end

	word_index (word: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		local
			has_left_boundary, has_right_boundary, found: BOOLEAN
			index: INTEGER
		do
			from index := start_index; Result := 1 until Result = 0 or else found or else index + word.count - 1 > count loop
				Result := substring_index (word, index)
				if Result > 0 then
					has_left_boundary := Result = 1 or else not is_alpha_numeric_item (Result - 1)
					has_right_boundary := Result + word.count - 1 = count or else not is_alpha_numeric_item (Result + word.count)
					if has_left_boundary and has_right_boundary then
						found := True
					else
						index := Result + 1
					end
				end
			end
		end

feature -- Element change

	append (s: like Current)
		local
			old_count: INTEGER
		do
			if s.has_foreign_characters then
				old_count := count
				append_string_8 (s) -- Append as STRING_8
				if has_foreign_characters then
					-- Normalize place holders
					codec.update_foreign_characters (area, s.count, old_count, s, Current, False)
				else
					copy_foreign_characters_from_other (s)
				end
				internal_hash_code := 0
			else
				append_string_8 (s)
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	append_string (s: READABLE_STRING_GENERAL)
		do
			if attached {EL_ASTRING} s as el_astring then
				append (el_astring)
			else
				append_unicode_general (s)
			end
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

	escape (escaper: EL_CHARACTER_ESCAPER)
		local
			l_escaped: STRING_32
		do
			l_escaped := escaper.escaped (to_unicode)
			if l_escaped.count > count then
				make_from_unicode (l_escaped)
			end
		end

	enclose (left, right: CHARACTER_32)
		do
			grow (count + 2)
			area.overlapping_move (0, 1, count)
			set_count (count + 1)
			put_unicode (left.natural_32_code, 1)
			append_unicode (right.natural_32_code)
		end

	left_adjust
			-- Remove leading whitespace.
		local
			nb, nb_space: INTEGER
			l_area: like area
		do
			if has_foreign_characters then
					-- Compute number of spaces at the left of current string.
				from
					nb := count - 1; l_area := area
				until
					nb_space > nb or else not is_space_character (l_area.item (nb_space))
				loop
					nb_space := nb_space + 1
				end
				keep_tail (nb + 1 - nb_space)
			else
				Precursor
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	insert_string (s: READABLE_STRING_GENERAL; i: INTEGER)
		local
			l_insert, l_tail: EL_ASTRING
		do
			l_insert := adapted_general (s)
			if has_foreign_characters then
				if l_insert.has_foreign_characters then
					l_tail := substring (i, count)
					keep_head (i - 1)
					append (l_insert); append (l_tail)
				else
					insert_string_8 (l_insert, i)
				end
			else
				-- Only other string has foreign characters
				if l_insert.has_foreign_characters then
					foreign_make_from_other (l_insert)
				end
				insert_string_8 (l_insert, i)
			end
		ensure
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

	prepend (astr: like Current)
		do
			if astr.has_foreign_characters then
				prepend_string_8 (astr)
				codec.update_foreign_characters (area, astr.count, 0, astr, Current, False)
				normalize_place_holders
			else
				prepend_string_8 (astr)
			end
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	prepend_string (str: READABLE_STRING_GENERAL)
		do
			if attached {like Current} str as astr then
				prepend (astr)
			else
				prepend_unicode_general (str)
			end
		end

	prepend_unicode_general (s: READABLE_STRING_GENERAL)
		local
			s_count, l_count: INTEGER
		do
			s_count := s.count; l_count := count
			grow (l_count + s_count)
			set_count (l_count + s_count)
			area.overlapping_move (0, s_count, l_count)
			encode (s, 0)
			if substring_has_place_holders (1, s_count) then
				normalize_place_holders
			end
			internal_hash_code := 0
		ensure then
			unicode_place_holders_normalized: is_normalized
		end

	precede, prepend_character (uc: CHARACTER_32)
		local
			new_foreign_character: CHARACTER_32; c: CHARACTER
		do
			c := encoded_character_32 (uc, $new_foreign_character)
			if new_foreign_character /= '%U' then
				foreign_extend (uc)
				c := upper_place_holder
			end
			prepend_character_8 (c)
			if is_place_holder_item (c) then
				normalize_place_holders
			end
		end

	put_character (uc: CHARACTER_32 i: INTEGER)
		do
			put_unicode (uc.natural_32_code, i)
		end

	put_unicode (v: like code; i: INTEGER)
			-- put unicode at i th position
		require -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			new_foreign_character: CHARACTER_32; c: CHARACTER
			has_foreign_characters_change: BOOLEAN; l_area: like area
		do
			l_area := area
			has_foreign_characters_change := is_place_holder_item (l_area [i - 1])
			c := encoded_character_32 (v.to_character_32, $new_foreign_character)
			if new_foreign_character /= '%U' then
				foreign_extend (v.to_character_32)
				c := upper_place_holder
			end
			l_area [i - 1] := c
			if has_foreign_characters_change or else is_place_holder_item (c) then
				normalize_place_holders
			end
			internal_hash_code := 0
		ensure
			inserted: unicode (i) = v
			stable_count: count = old count
			stable_before_i: Elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: Elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
			unicode_place_holders_normalized: is_normalized
		end

	quote (type: INTEGER)
		require
			type_is_single_or_double: type = 1 or type = 2
		local
			c: CHARACTER_32
		do
			if type = 1 then
				 c := '%''
			else
				 c := '"'
			end
			enclose (c, c)
		end

	replace_delimited_substring (left, right, new: EL_ASTRING; include_delimiter: BOOLEAN; start_index: INTEGER)
			-- Searching from start_index, replaces text delimited by left and right with 'new'
			-- Text replaced includeds delimiter if 'include_delimiter' is true
		local
			pos_left, pos_right, start_pos, end_pos: INTEGER
		do
			pos_left := substring_index (left, start_index)
			if pos_left > 0 then
				start_pos := pos_left + left.count
				pos_right := substring_index (right, start_pos)
				if pos_right > 0 then
					end_pos := pos_right - 1
					if include_delimiter then
						start_pos := start_pos - left.count
						end_pos := end_pos + right.count
					end
					replace_substring (new, start_pos, end_pos)
				end
			end
		end

	replace_substring (s: EL_ASTRING; start_index, end_index: INTEGER)
		local
			i, l_count: INTEGER; l_area, s_area: like area
			has_foreign_character_change, l_substring_has_place_holders: BOOLEAN
			new_foreign_character: CHARACTER_32; c: CHARACTER
		do
			l_substring_has_place_holders := substring_has_place_holders (start_index, end_index)
			Precursor (s, start_index, end_index)
			if s.has_foreign_characters and not has_foreign_characters then
				foreign_characters := s.foreign_characters.twin
			else
				if s.has_foreign_characters then
					s_area := s.area; l_area := area; l_count := s.count
					from i := 0 until i = l_count loop
						if s.is_place_holder_item (s_area [i]) then
							c := encoded_character_32 (s.code (i + 1).to_character_32, $new_foreign_character)
							if new_foreign_character /= '%U' then
								foreign_extend (new_foreign_character)
								c := upper_place_holder
							end
							l_area [start_index + i - 1] := c
						end
						i := i + 1
					end
					has_foreign_character_change := True
				else
					has_foreign_character_change := l_substring_has_place_holders
				end
			end
			if has_foreign_character_change then
				normalize_place_holders
			end
		ensure then
			normalized: is_normalized
		end

	replace_substring_all (a_original, a_new: READABLE_STRING_GENERAL)
		local
			original_8, new_8: STRING; original, new: EL_ASTRING
			normalization_required: BOOLEAN; old_foreign_count: INTEGER
		do
			original := adapted_general (a_original); new := adapted_general (a_new)
			if has_substring (original) then
				normalization_required := has_foreign_characters
				old_foreign_count := foreign_count
				new_8 := place_holder_compatible (new); original_8 := place_holder_compatible (original)
				normalization_required := not normalization_required implies old_foreign_count /= foreign_count
				replace_substring_all_8 (original_8, new_8)
				if normalization_required then
					normalize_place_holders
				end
			end
		ensure
			unicode_place_holders_normalized: is_normalized
		end

	replace_character (old_character, new_character: CHARACTER_32)
		local
			l_area: like area; i: INTEGER; found, has_foreign_character_change: BOOLEAN
			new_foreign_character: CHARACTER_32; old_chr, new_chr, c: CHARACTER
		do
			old_chr := encoded_character_32 (old_character, $new_foreign_character)
			if old_chr /= '%U' then
				new_chr := encoded_character_32 (new_character, $new_foreign_character)
				if new_foreign_character /= '%U' then
					foreign_extend (new_character)
					new_chr := upper_place_holder
				end
				has_foreign_character_change := is_place_holder_item (new_chr)
				l_area := area
				from i := 0 until i = l_area.count loop
					c := l_area [i]
					if c = old_chr then
						has_foreign_character_change := has_foreign_character_change or else is_place_holder_item (c)
						l_area [i] := new_chr
						found := True
					end
					i := i + 1
				end
				if found and then has_foreign_character_change then
					normalize_place_holders
				end
			end
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
					i < 0 or else not is_space_character (l_area [i])
				loop
					nb_space := nb_space + 1
					i := i - 1
				end
				keep_head (nb + 1 - nb_space)
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

	substitute_tuple (inserts: TUPLE)
		local
			insert_array: ARRAY [ANY]
			i: INTEGER
		do
			create insert_array.make (1, inserts.count)
			from i := 1 until i > inserts.count loop
				insert_array [i] := inserts.item (i)
				i := i + 1
			end
			substitute_indexable (insert_array)
		end

	substitute_indexable (inserts: INDEXABLE [ANY, INTEGER])
		require
			first_index_is_1: inserts.index_set.lower = 1
		local
			list: EL_DELIMITED_SUBSTRING_INTERVALS; out_inserts: ARRAY [EL_ASTRING]
			l_insert: EL_ASTRING; l_item: ANY
			size, i, l_count: INTEGER
		do
			create list.make (Current, "$S")
			l_count := inserts.index_set.count
			create out_inserts.make (1, l_count)
			from i := 1 until i > l_count loop
				l_item := inserts [i]
				if attached {EL_ASTRING} l_item as l_astring then
					l_insert := l_astring

				elseif attached {READABLE_STRING_GENERAL} l_item as l_readable_string then
					create l_insert.make_from_unicode (l_readable_string)
				else
					l_insert := l_item.out
				end
				out_inserts [i] := l_insert
				size := size + l_insert.count
				i := i + 1
			end
			size := size + count
			make (size)
			from list.start until list.after loop
				append (list.substring)
				if list.index <= out_inserts.count then
					append (out_inserts [list.index])
				end
				list.forth
			end
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

feature -- Removal

	prune_all (uc: CHARACTER_32)
			-- Remove all occurrences of `c'.
		local
			new_foreign_character: CHARACTER_32
		do
			prune_all_8 (encoded_character_32 (uc, $new_foreign_character))
			if foreign_has (uc) then
				normalize_place_holders
			end
		ensure
			unicode_place_holders_normalized: is_normalized
		end

	remove (i: INTEGER)
		local
			i_th_is_place_holder: BOOLEAN
		do
			i_th_is_place_holder := substring_has_place_holders (i, i)
			Precursor (i)
			if i_th_is_place_holder then
				normalize_place_holders
			end
		end

	remove_quotes
		require
			long_enough: count >= 2
		do
			remove_head (1); remove_tail (1)
		end

	remove_substring (start_index, end_index: INTEGER)
			-- TO DO: create some test for this
		local
			removed_string_had_placeholders: BOOLEAN
		do
			removed_string_had_placeholders := substring_has_place_holders (start_index, end_index)
			Precursor (start_index, end_index)
			if removed_string_had_placeholders then
				normalize_place_holders
			end
		end

	unescape (uc_escape_character: CHARACTER_32; uc_escaped_characters: HASH_TABLE [CHARACTER_32, CHARACTER_32])
		require
			double_escapes_are_literal_escapes: uc_escaped_characters [uc_escape_character] = uc_escape_character
		local
			pos_escape, start_index: INTEGER
		do
			from pos_escape := index_of (uc_escape_character, 1) until pos_escape = 0 loop
				if pos_escape + 1 <= count then
					uc_escaped_characters.search (unicode_item (pos_escape + 1))
					if uc_escaped_characters.found then
						put_unicode (uc_escaped_characters.found_item.natural_32_code, pos_escape + 1)
						remove (pos_escape)
						start_index := pos_escape + 1
					else
						start_index := pos_escape + 2
					end
					pos_escape := index_of (uc_escape_character, start_index)
				else
					pos_escape := 0
				end
			end
		end

	wipe_out
			-- Remove all characters.
		do
			Precursor
			foreign_make_empty
		end

feature -- Status query

	encoded_with (a_codec: EL_CODEC): BOOLEAN
		do
			Result := a_codec.same_type (codec)
		end

	has_quotes (a_count: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= a_count and a_count <= 2
		local
			c: CHARACTER_32
		do
			if a_count = 1 then
				c := '%''
			else
				c := '"'
			end
			Result := count >= 2 and then character_32_item (1) = c and then character_32_item (count) = c
		end

	has (uc: CHARACTER_32): BOOLEAN
		local
			new_foreign_character: CHARACTER_32; c: CHARACTER
		do
			c := encoded_character_32 (uc, $new_foreign_character)
			if new_foreign_character = '%U' then
				Result := has_character_8 (c)
			end
		end

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

	is_convertable (a_unicode: READABLE_STRING_GENERAL): BOOLEAN
			-- is unicode string potentially convertible to EL_ASTRING without overflowing foreign characters
			-- 'Potentially' means it is not absolutely guaranteed
		local
			i, l_count: INTEGER
			big_characters: ARRAYED_LIST [CHARACTER_32]
			c: CHARACTER_32
		do
			create big_characters.make (Maximum_place_holder_count + 1)
			l_count := a_unicode.count
			from i := 1 until big_characters.full or i > l_count loop
				if c > '%/255/' and then not big_characters.has (c) then
					big_characters.extend (c)
				end
				i := i + 1
			end
			Result := not big_characters.full
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

	starts_with (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached {EL_ASTRING} str as el_astring
				and then not (has_foreign_characters or el_astring.has_foreign_characters)
			then
				Result := starts_with_string_8 (el_astring)
			else
				Result := Precursor (str)
			end
		end

	valid_code (v: NATURAL_32): BOOLEAN
			-- Is `v' a valid code for a CHARACTER_32?
		do
			Result := True
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
			i: INTEGER; c: CHARACTER
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

	adapted_general (str: READABLE_STRING_GENERAL): EL_ASTRING
		do
			if attached {EL_ASTRING} str as astring then
				Result := astring
			else
				create Result.make_from_unicode (str)
			end
		end

	enclosed (left, right: CHARACTER_32): like Current
		do
			Result := twin
			Result.enclose (left, right)
		end

	escaped (escaper: EL_CHARACTER_ESCAPER): like Current
		do
			create Result.make_from_other (Current)
			Result.escape (escaper)
		end

	to_latin1: STRING
			-- coded as ISO-8859-1
		require
			no_foreign_characters: not has_foreign_characters
		local
			i, l_count: INTEGER; l_area: like area
		do
			if Codec.id = 1 then -- latin1
				Result := to_string_8
			else
				Result := to_unicode.to_string_8
			end
			if has_foreign_characters then
				-- Mark unencodeable as SUB character
				l_area := Result.area; l_count := Result.count
				from i := 0 until i = l_count loop
					if is_place_holder_item (l_area [i]) then
						l_area [i] := {ASCII}.sub.to_character_8
					end
					i := i + 1
				end
			end
		end

	to_utf8: STRING
		do
			Result := UTF.utf_32_string_to_utf_8_string_8 (to_unicode)
		end

	as_string_32, to_string_32, to_unicode: STRING_32
			-- UCS-4
		do
			create Result.make_filled ('%/000/', count)
			codec.decode (count, area, Result.area, Current)
		end

	to_unicode_general: READABLE_STRING_GENERAL
		do

		end

	as_string_8, to_string_8: STRING_8
		require
			no_foreign_characters: not has_foreign_characters
		do
			create Result.make_from_string (Current)
		end

	as_proper_case: EL_ASTRING
		do
			Result := twin
			Result.to_proper_case
		end

	plus alias "+" (s: READABLE_STRING_GENERAL): like Current
			-- <Precursor>
		do
			create Result.make (count + s.count)
			Result.append (Current)
			Result.append_string (s)
		end

	quoted (type: INTEGER): like Current
		do
			Result := twin
			Result.quote (type)
		end

	substituted_tuple alias "#$" (inserts: TUPLE): like Current
		do
			Result := twin
			Result.substitute_tuple (inserts)
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

	unescaped (
		uc_escape_character: CHARACTER_32; uc_escaped_characters: EL_HASH_TABLE [CHARACTER_32, CHARACTER_32]
	): like Current
		do
			create Result.make_from_other (Current)
			Result.unescape (uc_escape_character, uc_escaped_characters)
		end

feature -- Duplication

	substring_between (start_string, end_string: READABLE_STRING_GENERAL; start_index: INTEGER): like Current
			-- Returns string between substrings start_string and end_string from start_index.
			-- if end_string is empty or not found, returns the tail string starting from the character
			-- to the right of start_string. Returns empty string if start_string is not found.

			--	EXAMPLE:
			--			local
			--				log_line, ip_address: ASTRING
			--			do
			--				log_line := "Apr 13 05:34:49 myching sshd[7079]: Failed password for root from 43.255.191.152 port 55471 ssh2"
			--				ip_address := log_line.substring_between ("Failed password for root from ", " port")
			--				check
			--					correct_ip_address: ip_address.same_string ("43.255.191.152")
			--				end
			--			end
		local
			pos_start_string, pos_end_string: INTEGER
		do
			pos_start_string := substring_index (start_string, start_index)
			if pos_start_string > 0 then
				if end_string.is_empty then
					pos_end_string := count + 1
				else
					pos_end_string := substring_index (end_string, pos_start_string + start_string.count)
				end
				if pos_end_string > 0 then
					Result := substring (pos_start_string + start_string.count, pos_end_string - 1)
				else
					Result := substring (pos_start_string + start_string.count, count)
				end
			else
				create Result.make_empty
			end
		end

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

	stripped: like Current
		do
			Result := twin
			Result.left_adjust
			Result.right_adjust
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
				foreign_make_from_other (other)
			end
		end

feature {STRING_HANDLER, EL_ASTRING_SEARCHER} -- Implementation

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

feature {NONE} -- Implementation

	encode (s: READABLE_STRING_GENERAL; area_offset: INTEGER)
		require
			valid_area_offset: s.count > 0 implies area.valid_index (s.count + area_offset - 1)
		do
			codec.encode (s, area, area_offset, Current)
		end

	encoded_character_32 (uc: CHARACTER_32; new_foreign_character_32_ptr: POINTER): CHARACTER
			-- encode 'uc' as either a place_holder or latin character
			-- if a new place_holder is required, set value of boolean argument 'new_foreign_character_32_ptr'
			-- to last_encoded_foreign_character
		local
			l_codec: like codec
			last_encoded_foreign_character, null: CHARACTER_32
			character_ptr: POINTER
		do
			l_codec := codec
			l_codec.set_encoded_character (uc)
			last_encoded_foreign_character := l_codec.last_encoded_foreign_character
			if last_encoded_foreign_character = '%U' then
				Result := l_codec.last_encoded_character
			else
				Result := place_holder (last_encoded_foreign_character)
				if Result = '%U' then
					-- Copy last_encoded_foreign_character into argument
					character_ptr := $last_encoded_foreign_character
				else
					character_ptr := $null
				end
				new_foreign_character_32_ptr.memory_copy (character_ptr, {PLATFORM}.character_32_bytes)
			end
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

	place_holder_compatible (str: EL_ASTRING): STRING
			-- returns string with place holders swapped to be compatible with current
			-- returns argument string if it has no foreign characters

			-- Current place holders may no longer be normalized after call
		local
			i, l_count: INTEGER; c: CHARACTER; uc: CHARACTER_32
			l_area: like area
		do
			if str.has_foreign_characters then
				l_count := str.count
				create Result.make (l_count)
				l_area := str.area
				from i := 0 until i = l_count loop
					c := l_area [i]
					if str.is_place_holder_item (c) then
						uc := str.character_32_item (i + 1)
						c := place_holder (uc)
						if c = '%U' then
							foreign_extend (uc)
							c := upper_place_holder
						end
					end
					Result.append_character (c)
					i := i + 1
				end
			else
				Result := str
			end
		end

	same_items_as_other (other: like Current; a_count: INTEGER): BOOLEAN
		do
			Result := a_count = other.count 	and then area.same_items (other.area, other.area_lower, area_lower, a_count)
														and then foreign_characters ~ other.foreign_characters
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

	substring_has_place_holders (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := has_place_holders (upper_place_holder, start_index, end_index)
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

feature {NONE} -- Constants

	Codec: EL_CODEC
		once
			Result := system_codec
		end

	String_searcher: EL_ASTRING_SEARCHER
			-- String searcher specialized for READABLE_STRING_8 instances
		once
			create Result.make
		end

end
