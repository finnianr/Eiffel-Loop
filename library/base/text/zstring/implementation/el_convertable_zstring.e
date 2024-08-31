note
	description: "Routines to convert instance of ${ZSTRING} to another type or form"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-31 19:54:02 GMT (Saturday 31st August 2024)"
	revision: "73"

deferred class
	EL_CONVERTABLE_ZSTRING

inherit
	EL_TRANSFORMABLE_ZSTRING
		export
			{STRING_HANDLER} empty_unencoded_buffer
			{EL_CONVERTABLE_ZSTRING} all
			{ANY} is_valid_as_string_8
		end

	EL_WRITEABLE_ZSTRING

	EL_SHARED_IMMUTABLE_8_MANAGER; EL_SHARED_STRING_8_BUFFER_SCOPES

	EL_SET [CHARACTER]
		rename
			has as in_latin_15_disjoint_set
		undefine
			copy, is_equal, out
		end

feature -- To Strings

	as_encoded_8 (a_codec: EL_ZCODEC): STRING
		do
			if a_codec.encoded_as_utf (8) then
				Result := current_readable.to_utf_8
			else
				create Result.make (count)
				Result.set_count (count)
				a_codec.encode_as_string_8 (current_readable, Result.area, 0)
			end
		ensure
			all_encoded: not Result.has (Substitute)
		end

	db, debug_out: READABLE_STRING_GENERAL
		do
			if is_ascii then
				Result := Immutable_8.new_substring (area, 0, count)
			else
				Result := to_general
			end
		end

	out: STRING
			-- Printable representation
		local
			i, i_upper: INTEGER; c_i: CHARACTER
		do
			create Result.make (count)
			Result.set_count (count)

			if attached area as l_area and then attached Unicode_table as l_unicode
				and then attached Result.area as result_area
			then
				i_upper := count - 1
				from until i > i_upper loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							result_area [i] := '?'
						when Ascii_range then
							result_area [i] := c_i
					else
						result_area [i] := l_unicode [c_i.code].to_character_8
					end
					i := i + 1
				end
			end
		end

	to_shared_immutable_8: IMMUTABLE_STRING_8
		-- immutable string that shares same `area' as `Current'
		require
			completely_encoded: not has_mixed_encoding
		do
			Result := Immutable_8.new_substring (area, 0, count)
		end

	to_immutable_32: IMMUTABLE_STRING_32
		do
			create Result.make_filled (' ', count)
			if attached cursor_32 (Result) as immutable then
				codec.decode (count, area, immutable.area, 0)
				write_unencoded (immutable.area, 0, count, False)
			end
		end

	to_string_32, as_string_32, string: STRING_32
			-- UCS-4
		do
			create Result.make (count)
			internal_append_to_string_32 (Result, 0)
		end

	to_string_8, to_latin_1, as_string_8: STRING
			-- encoded as ISO-8859-1
		local
			encode_default: BOOLEAN; c8: EL_CHARACTER_8_ROUTINES
		do
			create Result.make (count)
			Result.set_count (count)

			if has_mixed_encoding or else not codec.is_latin_encoded then
				encode_default := True

			else
			-- Latin-X encoded
				inspect codec.id
					when 1 then
						Result.area.copy_data (area, 0, 0, count)

					when 15 then
					-- `Current' implements `EL_SET [CHARACTER]' as `in_latin_15_disjoint_set'
						if c8.has_member (Current, area, 0, count - 1) then
							encode_default := True
						else
							Result.area.copy_data (area, 0, 0, count)
						end
				else
					encode_default := True
				end
			end
			if encode_default then
				Latin_1_codec.encode_as_string_8 (current_readable, Result.area, 0)
			end
		end

	to_unicode, to_general: READABLE_STRING_GENERAL
		-- Unicode string with the smallest memory footprint possible for current string data
		-- Meaning it can be either STRING_8 or STRING_32
		local
			result_8: STRING; uc_i: CHARACTER_32; i, i_upper, block_index: INTEGER
			encoding_to_latin_1_failed, already_latin_1: BOOLEAN; result_area: like area
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; c_i: CHARACTER
		do
			already_latin_1 := Codec.encoded_as_latin (1)

			create result_8.make (count)
			result_8.set_count (count)
			result_area := result_8.area

			i_upper := area_upper
			if already_latin_1 and then not has_mixed_encoding then
				result_area.copy_data (area, 0, 0, count)

			elseif attached unicode_table as l_unicode_table and then attached unencoded_area as area_32
				and then attached area as l_area
			then
				from i := area_lower until encoding_to_latin_1_failed or i > i_upper loop
					c_i := l_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							uc_i := iter.item ($block_index, area_32, i + 1)
							if uc_i.code <= Max_8_bit_code then
								result_area [i] := uc_i.to_character_8
							else
								encoding_to_latin_1_failed := True
							end
						when Ascii_range then
							result_area [i] := c_i
					else
						if already_latin_1 then
							result_area [i] := c_i
						else
							uc_i := l_unicode_table [c_i.code]
							if uc_i.code <= Max_8_bit_code then
								result_area [i] := uc_i.to_character_8
							else
								encoding_to_latin_1_failed := True
							end
						end
					end
					i := i + 1
				end
			end
			if encoding_to_latin_1_failed then
				Result := to_string_32
			else
				Result := result_8
			end
		end

	to_utf_8: STRING
		-- converted to UTF-8 encoding
		do
			across String_8_scope as scope loop
				if attached scope.best_item (count) as utf_8 then
					append_to_utf_8 (utf_8)
					Result := utf_8.twin
				end
			end
		end

feature -- To list

	linear_representation: LIST [CHARACTER_32]
		local
			result_array: ARRAY [CHARACTER_32]
		do
			create result_array.make_filled ('%U', 1, count)
			Codec.decode (count, area, result_array.area, 0)
			write_unencoded (result_array.area, 0, count, False)
			create {ARRAYED_LIST [CHARACTER_32]} Result.make_from_array (result_array)
		ensure
			same_size: Result.count = count
			same_ends: Result.count > 0 implies Result.first = item (1) and Result.last = item (count)
		end

	lines: like split_list
		do
			Result := split_list ('%N')
		end

	split (a_separator: CHARACTER_32): EL_SPLIT_ZSTRING_ON_CHARACTER
		do
			create Result.make (current_zstring, a_separator)
		end

	split_intervals (delimiter: READABLE_STRING_GENERAL): EL_ZSTRING_SPLIT_INTERVALS
			-- substring intervals of `Current' split with `delimiter'
		do
			create Result.make_by_string (current_zstring, delimiter)
		end

	split_list (a_separator: CHARACTER_32): like new_list
			-- Split on `a_separator'.
		local
			part: like substring; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			separator: CHARACTER; call_index_of_8: BOOLEAN
			i, j, l_count, result_count, block_index: INTEGER
		do
			separator := encoded_character (a_separator)
			l_count := count
				-- Worse case allocation: every character is a separator
			inspect separator
				when Substitute then
					result_count := unencoded_occurrences (a_separator) + 1
			else
				result_count := String_8.occurrences (Current, separator) + 1
				call_index_of_8 := True
			end
			Result := new_list (result_count)
			if l_count > 0 then
				if call_index_of_8 then
					from i := 1 until i > l_count loop
						j := internal_index_of (separator, i)
						if j = 0 then
								-- No separator was found, we will
								-- simply create a list with a copy of
								-- Current in it.
							j := l_count + 1
						end
						part := substring (i, j - 1)
						Result.extend (part)
						i := j + 1
					end
				elseif attached unencoded_area as area_32 then
					from i := 1 until i > l_count loop
						j := iter.index_of ($block_index, area_32, a_separator, i)
						if j = 0 then
							j := l_count + 1
						end
						part := substring (i, j - 1)
						Result.extend (part)
						i := j + 1
					end
				end
				if j = l_count then
					check
						last_character_is_a_separator: item (j) = a_separator
					end
						-- A separator was found at the end of the string
					Result.extend (new_string (0))
				end
			else
					-- Extend empty string, since Current is empty.
				Result.extend (new_string (0))
			end
			check
				Result.count = occurrences (a_separator) + 1
			end
		end

	split_on_string (a_separator: READABLE_STRING_GENERAL): EL_SPLIT_ZSTRING_ON_STRING
		do
			create Result.make (current_zstring, a_separator)
		end

	substring_split (delimiter: EL_READABLE_ZSTRING): EL_ZSTRING_LIST
		-- split string on `delimiter' substring
		do
			if attached split_intervals (delimiter) as list then
				create Result.make (list.count)
				from list.start until list.after loop
					Result.extend (current_zstring.substring (list.item_lower, list.item_upper))
					list.forth
				end
			end
		end

feature -- To substring

	adjusted: like Current
		local
			left_count: INTEGER
		do
			left_count := leading_white_space
			if left_count = count then
				Result := new_string (0)
			else
				Result := substring (left_count + 1, count - trailing_white_space)
			end
		end

	substring_between (start_string, end_string: EL_READABLE_ZSTRING; start_index: INTEGER): like Current
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
				Result := new_string (0)
			end
		end

	substring_between_general (start_string, end_string: READABLE_STRING_GENERAL; start_index: INTEGER): like Current
		do
			Result := substring_between (
				adapted_argument (start_string, 1), adapted_argument (end_string, 2), start_index
			)
		end

	substring_end (start_index: INTEGER): like Current
		-- substring from `start_index' to `count'
		do
			Result := substring (start_index, count)
		end

	substring_start (end_index: INTEGER): like Current
		-- substring from 1 to `end_index'
		do
			Result := substring (1, end_index)
		end

feature -- Conversion

	as_canonically_spaced: like Current
		do
			Result := twin
			Result.to_canonically_spaced
		end

	cropped (left_delimiter, right_delimiter: CHARACTER_32): like Current
		-- `substring' between `left_delimiter' and `right_left_delimiter' or
		-- substring indices default to `1' and `count' for respective delimiters that are not found
		local
			left_index, right_index: INTEGER
		do
			if is_empty then
				Result := new_string (0)
			else
				left_index := index_of (left_delimiter, 1) + 1
				right_index := last_index_of (right_delimiter, count)
				if right_index = 0 then
					right_index := count
				else
					right_index := right_index - 1
				end
				Result := substring (left_index, right_index)
			end
		end

	enclosed (left, right: CHARACTER_32): like Current
		do
			Result := new_string (count + 2)
			Result.append_character (left)
			Result.append (current_readable)
			Result.append_character (right)
		ensure
			first_and_last: Result [1] = left and Result [Result.count] = right
			old_sandwiched: Result.substring (2, Result.count - 1) ~ current_readable
		end

	escaped (escaper: EL_STRING_ESCAPER [ZSTRING]): like Current
		do
			Result := escaper.escaped (current_readable, True)
		end

	joined alias "#+" (a_tuple: TUPLE): like Current
		-- concatentation of `Current' with elements of `a_tuple'
		do
			Result := new_string (count + Tuple.string_width (a_tuple))
			Result.append (current_readable)
			Tuple.write (a_tuple, Result.current_writable, Void)
		end

	mirrored: like Current
			-- Mirror image of string;
			-- Result for "Hello world" is "dlrow olleH".
		do
			Result := twin
			if count > 0 then
				Result.mirror
			end
		end

	multiplied (n: INTEGER): like Current
		-- duplicate `Current' string `n' times
		-- ("hello").multiplied (3) => "hellohellohello"
		require
			meaningful_multiplier: n >= 1
		local
			i: INTEGER
		do
			Result := new_string (n * count)
			from i := 1 until i > n loop
				Result.append (current_readable)
				i := i + 1
			end
		end

	quoted (type: INTEGER): like Current
		require
			type_is_single_double_or_appropriate: 1 <= type and type <= 3
		local
			c: CHARACTER_32
		do
			inspect type
				when 1 then
					c := '%''
				when 2 then
					c := '"'
				when 3 then -- appropriate for content
					if has ('"') then
						c := '%''
					else
						c := '"'
					end
			end
			Result := enclosed (c, c)
		end


	stripped: like Current
		do
			Result := twin
			Result.left_adjust
			Result.right_adjust
		end

	substituted_tuple alias "#$" (inserts: TUPLE): like Current
		-- Returns string with all '%S' characters replaced with string from respective position in `inserts'
		-- Literal '%S' characters are escaped with the escape sequence "%%%S" i.e. (%#)
		-- Note that in Eiffel, '%S' is the same as the sharp sign '#'
		require
			enough_substitution_markers: substitution_marker_count >= inserts.count
		local
			marker_pos, index, previous_marker_pos, i: INTEGER
		do
			if attached substitution_marker_index_list.area as marker_area then
				Result := new_string (count + Tuple.string_width (inserts) - marker_area.count)
				from until i = marker_area.count loop
					marker_pos := marker_area [i]
					if marker_pos - 1 > 0 and then item_8 (marker_pos - 1) = '%%' then
						Result.append_substring (current_readable, previous_marker_pos + 1, marker_pos - 2)
						Result.append_character ('%S')
					else
						index := index + 1
						Result.append_substring (current_readable, previous_marker_pos + 1, marker_pos - 1)
						Tuple.write_i_th (inserts, index, Result.current_writable)
					end
					previous_marker_pos := marker_pos
					i := i + 1
				end
				Result.append_substring (current_readable, previous_marker_pos + 1, count)
			end
		end

	translated (old_characters, new_characters: READABLE_STRING_GENERAL): like Current
		do
			Result := twin
			Result.translate (old_characters, new_characters)
		end

	unescaped (unescaper: EL_ZSTRING_UNESCAPER): like Current
		do
			create {ZSTRING} Result.make_from_zcode_area (unescaper.unescaped_array (current_readable))
		end

	unquoted: like Current
		do
			if count >= 2 then
				Result := substring (2, count - 1)
			else
				Result := twin
			end
		end

feature -- Case changed

	as_lower: like Current
			-- New object with all letters in lower case.
		do
			Result := twin
			Result.to_lower
		end

	as_proper_case: like Current
		do
			Result := twin
			Result.to_proper
		end

	as_upper: like Current
			-- New object with all letters in upper case
		do
			Result := twin
			Result.to_upper
		end

feature {NONE} -- Implementation

	in_latin_15_disjoint_set (c: CHARACTER): BOOLEAN
		-- `True' if `c' is member of disjoint set of latin-1 and latin-15 character
		do
			inspect c
				when '¤', '¦', '¨', '´', '¸', '¼' .. '¾' then
					Result := True
			else
			end
		end

	new_list (a_count: INTEGER): EL_ARRAYED_LIST [like Current]
		do
			create Result.make (a_count)
		end

end