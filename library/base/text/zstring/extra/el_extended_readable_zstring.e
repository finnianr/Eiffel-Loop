note
	description: "Extends the features of strings conforming to ${EL_READABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 12:57:54 GMT (Saturday 5th April 2025)"
	revision: "3"

class
	EL_EXTENDED_READABLE_ZSTRING

inherit
	EL_EXTENDED_READABLE_STRING_32
		rename
			area as unencoded_area,
			empty_target as empty_string
		redefine
			all_ascii, is_ascii, all_ascii_in_range,
			ends_with_character, has_alpha, has_member, starts_with_character,
			append_to, append_to_string_32, append_to_string_8, append_to_utf_8,
			append_substring_to_special_32, append_substring_to_special_8,
			is_i_th_alpha, is_i_th_alpha_numeric, is_i_th_space,
			matches_wildcard, new_shared_substring, same_string, write_utf_8_to
		end

	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area,
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		redefine
			target, set_target
		end

	EL_ZCODE_CONVERSION

	EL_STRING_BIT_COUNTABLE [ZSTRING]

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

create
	make_empty

feature -- Character query

	all_ascii, is_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		do
			Result := target.is_ascii
		end

	ends_with_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := target.ends_with_character (uc)
		end

	has_alpha: BOOLEAN
		do
			Result := target.has_alpha
		end

	has_member (set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		do
			Result := target.has_member (set)
		end

	starts_with_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := target.starts_with_character (uc)
		end

feature -- Comparison

	matches_wildcard (wildcard: EL_READABLE_ZSTRING): BOOLEAN
		-- try to match `wildcard' search term against string `s' with an asterisk either to the left,
		-- to the right or on both sides
		do
			Result := target.matches_wildcard (wildcard)
		end

	same_string (other: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := target.same_string (other)
		end

feature -- Basic operations

	append_to_string_32 (str: STRING_32)
		do
			target.append_to_string_32 (str)
		end

	append_to_string_8 (str: STRING_8)
		do
			target.append_to_string_8 (str)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		do
			target.append_to_utf_8 (utf_8_out)
		end

	write_utf_8_to (utf_8_out: EL_WRITABLE)
		do
			target.write_utf_8_to (utf_8_out)
		end

feature {STRING_HANDLER} -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_upper, l_block_index: INTEGER; c_i: CHARACTER; uc: CHARACTER_32
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			codec.decode (n, area, destination, 0)
			if attached area as l_area and then attached unencoded_area as area_32
				and then attached unicode_table as unicode
			then
				i_upper := source_index + index_lower + n - 1
				from i := source_index + index_lower until i > i_upper loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc := iter.item ($l_block_index, area_32, i - index_lower + 1)
					else
						uc := unicode [c_i.code]
					end
					destination.extend (uc)
					i := i + 1
				end
			end
		end

feature -- Element change

	set_target (a_target: like target)
		do
			Precursor (a_target)
			area := a_target.area
		end

feature {NONE} -- Implementation

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

	is_i_th_alpha (unencoded: like unencoded_area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `area'  is alphabetical or numeric
		do
			Result := target.is_alpha_item (i - 1)
		end

	is_i_th_alpha_numeric (unencoded: like unencoded_area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `area'  is alphabetical or numeric
		do
			Result := target.is_alpha_numeric_item (i - 1)
		end

	is_i_th_space (unencoded: like unencoded_area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `unencoded'  is white space
		do
			Result := target.is_space_item (i - 1)
		end

	new_shared_substring (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		do
			Result := Substring_buffer.copied_substring (str, start_index, end_index)
		end

	other_area (other: EL_READABLE_ZSTRING): like unencoded_area
		require else
			not_applicable: False
		do
			Result := other.unencoded_area
		end

	other_index_lower (other: EL_READABLE_ZSTRING): INTEGER
		do
			Result := 0
		end

feature {NONE} -- Internal attriutes

	area: SPECIAL [CHARACTER_8]
		-- target area

	target: EL_READABLE_ZSTRING

feature {NONE} -- Constants

	Substring_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end