note
	description: "Extends the features of strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 11:43:13 GMT (Saturday 5th April 2025)"
	revision: "2"

deferred class
	EL_EXTENDED_READABLE_STRING_I [CHAR -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

	EL_UC_ROUTINES
		rename
			utf_8_byte_count as code_utf_8_byte_count
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

	EL_STRING_HANDLER

	EL_SHARED_UNICODE_PROPERTY; EL_SHARED_UTF_8_SEQUENCE

feature -- Measurement

	count: INTEGER
		do
			Result := target.count
		end

	utf_8_byte_count: INTEGER
		local
			i, upper: INTEGER
		do
			if attached area as l_area then
				from i := index_lower; upper := index_upper until i > upper loop
					Result := Result + code_utf_8_byte_count (to_character_32 (l_area [i]).natural_32_code)
					i := i + 1
				end
			end
		end

feature -- Character query

	all_ascii, is_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		do
			Result := all_ascii_in_range (area, 0, index_upper)
		end

	ends_with_character (c: CHAR): BOOLEAN
		do
			Result := index_upper >= index_lower and then area [index_upper] = c
		end

	has_alpha: BOOLEAN
		do
			Result := substring_has_alpha (area, index_lower, index_upper)
		end

	has_member (set: EL_SET [CHAR]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		local
			i, upper: INTEGER
		do
			if attached area as l_area then
				from i := index_lower; upper := index_upper until i > upper or Result loop
					Result := set.has (l_area [i])
					i := i + 1
				end
			end
		end

	is_ascii_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)'
		-- are in the ASCII character set: 0 .. 127
		require
			valid_end_index: end_index <= count
		local
			lower, upper: INTEGER
		do
			upper := index_upper - (count - end_index)
			lower := index_lower + start_index - 1
			Result := all_ascii_in_range (area, lower, upper)
		end

	starts_with_character (c: CHAR): BOOLEAN
		do
			Result := index_upper >= index_lower and then area [index_lower] = c
		end

feature -- Status query

	ends_with (leading: like READABLE_X): BOOLEAN
		deferred
		end

	has_substring (other: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	matches_wildcard (wildcard: like READABLE_X): BOOLEAN
		-- try to match `wildcard' search term against string `s' with an asterisk either to the left,
		-- to the right or on both sides
		local
			any_ending, any_start: BOOLEAN; start_index, end_index: INTEGER
			search_string: like READABLE_X
		do
			start_index := 1; end_index := wildcard.count
			inspect wildcard.count
				when 0 then
				when 1 then
					if wildcard [1].code = {ASCII}.Star then
						any_ending := True; any_start := True
					end
			else
				if wildcard [wildcard.count].code = {ASCII}.Star then
					end_index := end_index - 1
					any_ending := True
				end
				if wildcard [1].code = {ASCII}.Star then
					start_index := start_index + 1
					any_start := True
				end
			end
			if start_index - end_index + 1 = wildcard.count then
				search_string := wildcard
			else
				search_string := new_shared_substring (wildcard, start_index, end_index)
			end
			if any_ending and any_start then
				if wildcard.count = 1 then
					Result := True
				else
					Result := has_substring (search_string)
				end

			elseif any_ending then
				Result := starts_with (search_string)

			elseif any_start then
				Result := ends_with (search_string)
			else
				Result := same_string (wildcard)
			end
		end

	same_string (other: like READABLE_X): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		local
			l_count: INTEGER
		do
			l_count := count
			if l_count > 0 and then l_count = other.count then
				Result := same_area_items (area, other_area (other), index_lower, other_index_lower (other), l_count)
			end
		end

	starts_with (leading: like READABLE_X): BOOLEAN
		deferred
		end

feature -- Basic operations

	append_substring_to_string_32 (str: STRING_32; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index <= end_index + 1
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i_upper, i_lower, l_count, offset: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1
				append_substring_to_special_32 (area, i_lower, i_upper, str.area, offset)
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_substring_to_string_8 (str: STRING_8; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index <= end_index + 1
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i_upper, i_lower, l_count, offset: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1
				append_substring_to_special_8 (area, i_lower, i_upper, str.area, offset)
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_to_string_32 (str: STRING_32)
		do
			append_substring_to_string_32 (str, 1, target.count)
		end

	append_to_string_8 (str: STRING_8)
		require
			valid_as_string_8: is_valid_as_string_8
		do
			append_substring_to_string_8 (str, 1, target.count)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		local
			i, upper: INTEGER; code_i: NATURAL
		do
			utf_8_out.grow (utf_8_out.count + utf_8_byte_count)
			upper := index_upper
			if attached area as l_area and then attached Utf_8_sequence as utf_8 then
				from i := index_lower until i > upper loop
					code_i := to_character_32 (l_area [i]).natural_32_code
					if code_i <= 0x7F then
						utf_8_out.append_character (code_i.to_character_8)
					else
						utf_8.set_area (code_i)
						utf_8.append_to_string (utf_8_out)
					end
					i := i + 1
				end
			end
		end

	write_utf_8_to (utf_8_out: EL_WRITABLE)
		local
			i, i_upper: INTEGER; code_i: NATURAL
		do
			i_upper := index_upper
			if attached area as l_area and then attached Utf_8_sequence as utf_8 then
				from i := index_lower until i > i_upper loop
					code_i := to_character_32 (l_area [i]).natural_32_code
					if code_i <= 0x7F then
						utf_8_out.write_encoded_character_8 (code_i.to_character_8)
					else
						utf_8.set_area (code_i)
						utf_8.write (utf_8_out)
					end
					i := i + 1
				end
			end
		end

feature -- Contract Support

	ends_with_target (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, 1)
		end

	ends_with_target_substring (str: READABLE_STRING_GENERAL; target_index, index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, target_index)
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := target.is_valid_as_string_8
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
		end

feature {NONE} -- Implementation

	all_ascii_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		deferred
		end

	append_substring_to_special_32 (
		a_area: like area; i_lower, i_upper: INTEGER; area_32: SPECIAL [CHARACTER_32]; a_offset: INTEGER
	)
		local
			i, offset: INTEGER
		do
			offset := a_offset
			from i := i_lower until i > i_upper loop
				area_32 [offset] := to_character_32 (a_area [i])
				offset := offset + 1
				i := i + 1
			end
		end

	append_substring_to_special_8 (
		a_area: like area; i_lower, i_upper: INTEGER; area_8: SPECIAL [CHARACTER_8]; a_offset: INTEGER
	)
		local
			i, offset: INTEGER
		do
			offset := a_offset
			from i := i_lower until i > i_upper loop
				area_8 [offset] := to_character_8 (a_area [i])
				offset := offset + 1
				i := i + 1
			end
		end

	new_shared_substring (str: like READABLE_X; start_index, end_index: INTEGER): like READABLE_X
		deferred
		end

	other_area (other: like READABLE_X): like area
		deferred
		end

	other_index_lower (other: like READABLE_X): INTEGER
		deferred
		end

	same_area_items (a, b: like area; a_offset, b_offset, n: INTEGER): BOOLEAN
		-- Are the `n' characters of `b' from `b_offset' position the same as
		-- the `n' characters of `a' from `a_offset'?
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		require
			other_not_void: b /= Void
			source_index_non_negative: b_offset >= 0
			destination_index_non_negative: a_offset >= 0
			n_non_negative: n >= 0
			n_is_small_enough_for_source: b_offset + n <= b.count
			n_is_small_enough_for_destination: a_offset + n <= a.count
		local
			i, j, nb: INTEGER
		do
			if a = b and a_offset = b_offset then
				Result := True
			else
				Result := True
				from
					i := b_offset; j := a_offset
					nb := b_offset + n
				until
					i = nb
				loop
					if b [i] /= a [j] then
						Result := False
						i := nb - 1
					end
					i := i + 1
					j := j + 1
				end
			end
		ensure
			valid_on_empty_area: (n = 0) implies Result
		end

	substring_has_alpha (a_area: like area; start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			from i := start_index until Result or else i > end_index loop
				Result := is_i_th_alpha (a_area, i)
				i := i + 1
			end
		end

feature {STRING_HANDLER} -- Deferred

	area: SPECIAL [CHAR]
		deferred
		end

	empty_target: like target
		deferred
		end

	index_lower: INTEGER
		deferred
		end

	index_upper: INTEGER
		deferred
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		deferred
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end

	to_character_32 (c: CHAR): CHARACTER_32
		deferred
		end

	to_character_8 (c: CHAR): CHARACTER_8
		deferred
		end

	to_natural_32_code (c: CHAR): NATURAL
		deferred
		end

feature {NONE} -- Type definitions

	READABLE_X: READABLE_STRING_GENERAL
		require
			never_called: False
		deferred
		end

end