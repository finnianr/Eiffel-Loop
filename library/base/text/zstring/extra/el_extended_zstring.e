note
	description: "Extended zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 15:12:19 GMT (Friday 11th April 2025)"
	revision: "1"

class
	EL_EXTENDED_ZSTRING

inherit
	ZSTRING
		rename
			append_to as append_to_other,
			is_ascii_substring as is_other_ascii_substring,
			set_count as set_string_count
		undefine
			same_string
		redefine
			make, resize, share, trim
		end

	EL_EXTENDED_STRING_32
		rename
			area as unencoded_area,
			empty_target as empty_string,
			set_target as share
		undefine
			append_area_32, append_to_string_32, append_to_string_8, append_to_utf_8,
			count,
			ends_with_character,
			has_alpha, has_enclosing, has_member, has_quotes,
			is_ascii, is_ascii_substring, is_alpha_numeric, is_canonically_spaced, is_valid_as_string_8,
			leading_occurrences,
			matches_wildcard,
			remove_bookends, replace_character, remove_double, remove_single,
			starts_with_character,
			to_canonically_spaced, to_utf_8,
			translate, translate_or_delete, translate_with_deletion,
			utf_8_byte_count, valid_index, write_utf_8_to,
			String_32_searcher
		redefine
			all_alpha_numeric_in_range, all_ascii_in_range,
			append_substring_to_special_32, append_substring_to_special_8,
			append_to,
			index_of_character_type_change,
			is_c_identifier_in_range, is_eiffel_identifier_in_range,
			is_i_th_alpha, is_i_th_alpha_numeric, is_i_th_space,
			new_shared_substring,
			occurrences_in_area_bounds,
			parse_substring_in_range,
			right_bracket_index
		end

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			shared_string := Current
		end

feature -- Status query

	is_ascii_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)'
		-- are in the ASCII character set: 0 .. 127
		do
--			Result := all_ascii_in_range (unen, lower_abs (start_index), upper_abs (end_index))
		end

feature -- Element change

	share (other: EL_ZSTRING)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			Precursor (other)
			shared_string := other
		end

feature {STRING_HANDLER} -- Basic operations

	append_to (special_out: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_upper, l_block_index: INTEGER; c_i: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			codec.decode (n, area, special_out, 0)
			if attached area as l_area and then attached unencoded_area as unencoded
				and then attached unicode_table as uc_table
			then
				i_upper := (index_lower + source_index + n - 1).min (index_upper)
				from i := index_lower + source_index until i > i_upper loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							special_out.extend (iter.item ($l_block_index, unencoded, i - index_lower + 1))

						when Ascii_range then
							special_out.extend (c_i)
					else
						special_out.extend (uc_table [c_i.code])
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	all_alpha_numeric_in_range (unencoded: like unencoded_area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are alpha-numeric
		local
			i, block_index: INTEGER; c_i: CHARACTER_8; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			if attached Unicode_table as uc_table and then attached area as l_area then
				Result := True
				from i := i_lower until i > i_upper or not Result loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							Result := iter.item ($block_index, unencoded, i + 1).is_alpha_numeric

						when Ascii_range then
							Result := c_i.is_alpha_numeric
					else
						Result := uc_table [c_i.code].is_alpha_numeric
					end
					i := i + 1
				end
			end
		end

	all_ascii_in_range (unencoded: like unencoded_area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		local
			i: INTEGER; c: EL_CHARACTER_8_ROUTINES; substitute_found: BOOLEAN
		do
			if attached area as l_area then
				from i := i_lower until i > i_upper or substitute_found loop
					inspect l_area [i]
						when Substitute then
							substitute_found := True
					else
					end
					i := i + 1
				end
				Result := not substitute_found and then c.is_ascii_area (area, i_lower, i_upper)
			end
		end

	append_substring_to_special_32 (
		unencoded: like unencoded_area; i_lower, i_upper: INTEGER
		special_32: SPECIAL [CHARACTER_32]; a_offset: INTEGER
	)
		local
			i, offset, block_index: INTEGER; c_i: CHARACTER_8; uc_i: CHARACTER_32
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			offset := a_offset
			if attached Unicode_table as uc_table and then attached area as l_area then
				from i := i_lower until i > i_upper loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							uc_i:= iter.item ($block_index, unencoded, i + 1)

						when Ascii_range then
							uc_i := c_i
					else
						uc_i := uc_table [c_i.code]
					end
					special_32.put (uc_i, offset)
					i := i + 1; offset := offset + 1
				end
			end
		end

	append_substring_to_special_8 (
		unencoded: like unencoded_area; i_lower, i_upper: INTEGER
		special_8: SPECIAL [CHARACTER_8]; a_offset: INTEGER
	)
		local
			i, offset, block_index: INTEGER; c_i: CHARACTER_8; uc_i: CHARACTER_32
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			offset := a_offset
			if attached Unicode_table as uc_table and then attached area as l_area then
				from i := i_lower until i > i_upper loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							uc_i:= iter.item ($block_index, unencoded, i + 1)

						when Ascii_range then
							uc_i := c_i
					else
						uc_i := uc_table [c_i.code]
					end
					if uc_i.is_character_8 then
						special_8.put (uc_i.to_character_8, offset)
					else
						special_8.put (Substitute, offset)
					end
					i := i + 1; offset := offset + 1
				end
			end
		end

	index_of_character_type_change (
		unencoded: like unencoded_area; i_lower, i_upper: INTEGER; find_word: BOOLEAN; a_unicode: like Unicode_property
	): INTEGER
		-- index of next character that changes status from `c.is_space' to `not c.is_space'
		-- when `find_word' is true look for change to `not c.is_space'
		local
			i, block_index: INTEGER; c_i: CHARACTER_8; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			i_th_is_space, break: BOOLEAN
		do
			if attached Unicode_table as uc_table and then attached area as l_area then
				from i := i_lower until i > i_upper or break loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							i_th_is_space := a_unicode.is_space (iter.item ($block_index, unencoded, i + 1))

						when Ascii_range then
							i_th_is_space := c_i.is_space
					else
						i_th_is_space := a_unicode.is_space (uc_table [c_i.code])
					end
					if find_word then
						if not i_th_is_space then
							break := True
						else
							i := i + 1
						end
					else
						if i_th_is_space then
							break := True
						else
							i := i + 1
						end
					end
				end
			end
			Result := i
		end

	is_c_identifier_in_range (unencoded: like unencoded_area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if characters in `a_area' from `i_lower' to `i_upper' constitute
		-- a C language identifier
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_c_identifier_area (area, i_lower, i_upper)
		end

	is_eiffel_identifier_in_range (
		unencoded: like unencoded_area; i_lower, i_upper: INTEGER case: NATURAL_8
	): BOOLEAN
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_eiffel_identifier_area (area, i_lower, i_upper, case)
		end

	is_i_th_alpha (unencoded: like unencoded_area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `area'  is alphabetical or numeric
		do
			Result := is_alpha_item (i - 1)
		end

	is_i_th_alpha_numeric (unencoded: like unencoded_area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `area'  is alphabetical or numeric
		do
			Result := is_alpha_numeric_item (i - 1)
		end

	is_i_th_space (unencoded: like unencoded_area; i: INTEGER; a_unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `unencoded'  is white space
		do
			Result := is_space_item (i - 1)
		end

	copy_area_32_data (unencoded: like unencoded_area; source: SPECIAL [CHARACTER_32])
		require else
			not_applicable: False
		do
		end

	new_readable: EL_EXTENDED_ZSTRING
		do
			create Result.make_empty
		end

	new_substring (start_index, end_index: INTEGER): ZSTRING
		do
			create Result.make_from_substring (Current, start_index, end_index)
		end

	occurrences_in_area_bounds (unencoded: like unencoded_area; uc: CHARACTER_32; i_lower, i_upper: INTEGER): INTEGER
		-- count of `c' occurrences in area between `i_lower' and `i_upper'
		local
			i, block_index: INTEGER; c_i, ascii_uc: CHARACTER_8; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			if uc.natural_32_code <= 0x7F then
				ascii_uc := uc.to_character_8
			end
			if attached Unicode_table as uc_table and then attached area as l_area then
				from i := i_lower until i > i_upper loop
					inspect ascii_uc
						when '%U' then
							c_i := l_area [i]
							inspect character_8_band (c_i)
								when Substitute then
									Result := Result + (iter.item ($block_index, unencoded, i + 1) = uc).to_integer

								when Ascii_range then
									do_nothing
							else
								Result := Result + (uc_table [c_i.code] = uc).to_integer
							end
					else
					-- `uc' is ASCII character
						Result := Result + (l_area [i] = ascii_uc).to_integer
					end
					i := i + 1
				end
			end
		end

	other_area (other: EL_READABLE_ZSTRING): like unencoded_area
		do
			Result := other.unencoded_area
		end

	other_index_lower (other: EL_READABLE_ZSTRING): INTEGER
		do
			Result := other.area_lower
		end

	new_shared_substring (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		do
			Result := Substring_buffer.copied_substring (str, start_index, end_index)
		end

	parse_substring_in_range (
		unencoded: like unencoded_area; type, i_lower, i_upper: INTEGER; convertor: STRING_TO_NUMERIC_CONVERTOR
	)
		local
			i: INTEGER; failed: BOOLEAN; c_i: CHARACTER_8
		do
			if attached area as l_area then
				from i := i_lower until i > i_upper or failed loop
					c_i := l_area [i]
					inspect c_i
						when '0' .. '9', 'e', 'E', '.', '+', '-' then
							convertor.parse_character (c_i)
							if convertor.parse_successful then
								i := i + 1
							else
								failed := True
							end
					else
						convertor.reset (type); failed := True
					end
				end
			end
		end

	resize (newsize: INTEGER)
		-- Rearrange string so that it can accommodate at least `newsize' characters.
		do
			Precursor (newsize)
			if shared_string /= Current then
				shared_string.share (Current)
			end
		end

	right_bracket_index (unencoded: like unencoded_area; left_bracket: CHARACTER_32; start_index, end_index: INTEGER): INTEGER
		-- index of right bracket corresponding to `left_bracket'. `-1' if not found.
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.right_bracket_index (area, left_bracket.to_character_8, start_index, end_index)
		end

	set_count (n: INTEGER)
		do
			set_string_count (n)
			if shared_string /= Current then
				shared_string.set_count (n)
			end
		end

	split_on_character (separator: CHARACTER_32): like Split_string_32
		do
			Result := Split_string_32
			Result.set_target (Current); Result.set_separator (separator)
		end

	trim
		 -- reallocate to new size
		do
			if attached area as l_area then
				Precursor
				if l_area /= area and then shared_string /= Current then
					shared_string.share (Current)
				end
			end
		end

feature {NONE} -- Internal attributes

	shared_string: ZSTRING

feature {NONE} -- Constants

	Split_string_32: EL_SPLIT_ZSTRING_ON_CHARACTER
		once
			create Result.make (Empty_string, '_')
		end

	Substring_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end
end