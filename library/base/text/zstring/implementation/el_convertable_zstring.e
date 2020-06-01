note
	description: "Routines to convert instance of [$source EL_ZSTRING] to another type or form"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-01 13:28:16 GMT (Monday 1st June 2020)"
	revision: "2"

deferred class
	EL_CONVERTABLE_ZSTRING

inherit
	EL_TRANSFORMABLE_ZSTRING
		export
			{STRING_HANDLER} extendible_unencoded
			{EL_CONVERTABLE_ZSTRING} all
		end

	EL_MODULE_UTF

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_STRING_8
		rename
			once_string_8 as shared_once_string_8
		end

	EL_SHARED_UTF_8_ZCODEC

feature -- Measurement

	substitution_marker_count: INTEGER
		deferred
		end

feature -- To Strings

	as_encoded_8 (a_codec: EL_ZCODEC): STRING
		local
			l_result_area: like to_latin_1.area
			l_unicode: CHARACTER_32; l_area: SPECIAL [CHARACTER_32];
			str_32: STRING_32; l_count, i: INTEGER
		do
			if a_codec.encoded_as_utf (8) then
				str_32 := empty_once_string_32; append_to_string_32 (str_32)
				create Result.make (Utf.utf_8_bytes_count (str_32, 1, count))
				UTF.utf_32_string_into_utf_8_string_8 (str_32, Result)

			elseif codec.same_as (a_codec) then
				create Result.make_filled (Unencoded_character, count)
				Result.area.copy_data (area, 0, 0, count)

			elseif a_codec.encoded_as_latin (1) then
				l_count := count
				create Result.make_filled (Unencoded_character, l_count)
				str_32 := empty_once_string_32
				append_to_string_32 (str_32)
				l_area := str_32.area; l_result_area := Result.area
				from i := 0  until i = l_count loop
					l_unicode := l_area [i]
					if l_unicode.natural_32_code <= 0xFF then
						l_result_area [i] := l_unicode.to_character_8
					end
					i := i + 1
				end
			else
				str_32 := empty_once_string_32
				append_to_string_32 (str_32)
				create Result.make_filled ('%U', count)
				a_codec.encode (str_32, Result.area, 0, extendible_unencoded)
			end
		ensure
			all_encoded: not Result.has (Unencoded_character)
		end

	out: STRING
			-- Printable representation
		local
			c: CHARACTER; i: INTEGER; l_area: like area
		do
			create Result.make (count)
			l_area := area
			from i := 1 until i > count loop
				c := l_area [i - 1]
				if c = Unencoded_character then
					Result.extend ('?')
				else
					Result.extend (codec.as_unicode_character (c).to_character_8)
				end
				i := i + 1
			end
		end

	to_string_32, as_string_32: STRING_32
			-- UCS-4
		do
			create Result.make (count)
			append_to_string_32 (Result)
		end

	to_string_8, to_latin_1, as_string_8: STRING
			-- encoded as ISO-8859-1
		do
			Result := as_encoded_8 (Latin_1_codec)
		end

	to_unicode, to_general: READABLE_STRING_GENERAL
		local
			str_32: STRING_32
		do
			str_32 := empty_once_string_32
			append_to_string_32 (str_32)
			if str_32.is_valid_as_string_8 then
				Result := str_32.as_string_8
			else
				Result := str_32.twin
			end
		end

	to_utf_8: STRING
		do
			Result := as_encoded_8 (Utf_8_codec)
		end

feature -- To list

	linear_representation: LIST [CHARACTER_32]
		local
			char_32_array: ARRAYED_LIST [CHARACTER_32]
			str_32: STRING_32
		do
			create char_32_array.make_filled (count)
			str_32 := empty_once_string_32
			append_to_string_32 (str_32)
			char_32_array.area.copy_data (str_32.area, 0, 0, count)
			Result := char_32_array
		end

	lines: like split
		do
			Result := split ('%N')
		end

	split (a_separator: CHARACTER_32): LIST [like Current]
			-- Split on `a_separator'.
		local
			l_list: ARRAYED_LIST [like Current]; part: like Current; i, j, l_count, result_count: INTEGER
			separator: CHARACTER; call_index_of_8: BOOLEAN; separator_code: NATURAL
		do
			separator := encoded_character (a_separator)
			l_count := count
				-- Worse case allocation: every character is a separator
			if separator = Unencoded_character then
				separator_code := a_separator.natural_32_code
				result_count := unencoded_occurrences (separator_code) + 1
			else
				result_count := internal_occurrences (separator) + 1
				call_index_of_8 := True
			end
			create l_list.make (result_count)
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
						l_list.extend (part)
						i := j + 1
					end
				else
					from i := 1 until i > l_count loop
						j := unencoded_index_of (separator_code, i)
						if j = 0 then
							j := l_count + 1
						end
						part := substring (i, j - 1)
						l_list.extend (part)
						i := j + 1
					end
				end
				if j = l_count then
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
		end

	split_intervals (delimiter: READABLE_STRING_GENERAL): EL_SPLIT_ZSTRING_LIST
			-- substring intervals of `Current' split with `delimiter'
		do
			if attached {ZSTRING} Current as zstr then
				create Result.make (zstr, delimiter)
			else
				create Result.make_empty
			end
		end

	substring_index_list (delimiter: EL_READABLE_ZSTRING): like internal_substring_index_list
		do
			Result := internal_substring_index_list (adapted_argument (delimiter, 1)).twin
		end

	substring_intervals (str: READABLE_STRING_GENERAL): EL_OCCURRENCE_INTERVALS [ZSTRING]
		do
			if attached {ZSTRING} Current as zstr then
				create Result.make (zstr, str)
			else
				create Result.make_empty
			end
		end

	substring_split (delimiter: EL_READABLE_ZSTRING): EL_STRING_LIST [ZSTRING]
		-- split string on substring delimiter
		do
			Result := split_intervals (delimiter).as_list
		end

feature -- To substring

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
			Result := substring_between (adapted_argument (start_string, 1), adapted_argument (end_string, 2), start_index)
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

	enclosed (left, right: CHARACTER_32): like Current
		do
			Result := twin
			Result.enclose (left, right)
		end

	escaped (escaper: EL_ZSTRING_ESCAPER): like Current
		do
			Result := escaper.escaped (current_readable, True)
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
		do
			Result := twin
			Result.multiply (n)
		end

	quoted (type: INTEGER): like Current
		do
			Result := twin
			Result.quote (type)
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
			l_index_list: like internal_substring_index_list
			marker_pos, index, previous_marker_pos: INTEGER
		do
			l_index_list := internal_substring_index_list (Substitution_marker)
			Result := new_string (count + tuple_as_string_count (inserts) - l_index_list.count)
			from l_index_list.start until l_index_list.after loop
				marker_pos := l_index_list.item
				if marker_pos - 1 > 0 and then item (marker_pos - 1) = '%%' then
					Result.append_substring (current_readable, previous_marker_pos + 1, marker_pos - 2)
					Result.append_character ('%S')
				else
					index := index + 1
					Result.append_substring (current_readable, previous_marker_pos + 1, marker_pos - 1)
					Result.append_tuple_item (inserts, index)
				end
				previous_marker_pos := marker_pos
				l_index_list.forth
			end
			Result.append_substring (current_readable, previous_marker_pos + 1, count)
		end

	translated (old_characters, new_characters: EL_READABLE_ZSTRING): like Current
		do
			Result := twin
			Result.translate (old_characters, new_characters)
		end

	translated_general (old_characters, new_characters: READABLE_STRING_GENERAL): like Current
		do
			Result := twin
			Result.translate_general (old_characters, new_characters)
		end

	unescaped (unescaper: EL_ZSTRING_UNESCAPER): like Current
		do
			create {ZSTRING} Result.make_unescaped (unescaper, current_readable)
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
			Result.to_proper_case
		end

	as_upper: like Current
			-- New object with all letters in upper case
		do
			Result := twin
			Result.to_upper
		end

feature {NONE} -- Deferred Implementation

	append_to_string_32 (output: STRING_32)
		deferred
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		deferred
		end

	new_string (n: INTEGER): like Current
		deferred
		end

	occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		deferred
		end

	substitution_marker: EL_ZSTRING
		deferred
		end

feature {NONE} -- Implementation

	natural_64_width (natural_64: NATURAL_64): INTEGER
		local
			quotient: NATURAL_64
		do
			if natural_64 = 0 then
				Result := 1
			else
				from quotient := natural_64 until quotient = 0 loop
					Result := Result + 1
					quotient := quotient // 10
				end
			end
		end

	tuple_as_string_count (tuple: TUPLE): INTEGER
		local
			l_count, i: INTEGER; l_reference: ANY
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Boolean_code then
						l_count := 4
					when {TUPLE}.Character_code then
						l_count := 1
					when {TUPLE}.Integer_16_code then
						l_count := natural_64_width (tuple.integer_16_item (i).abs.to_natural_64)

					when {TUPLE}.Integer_32_code then
						l_count := natural_64_width (tuple.integer_32_item (i).abs.to_natural_64)

					when {TUPLE}.Integer_64_code then
						l_count := natural_64_width (tuple.integer_64_item (i).abs.to_natural_64)

					when {TUPLE}.Natural_16_code then
						l_count := natural_64_width (tuple.natural_16_item (i).to_natural_64)

					when {TUPLE}.Natural_32_code then
						l_count := natural_64_width (tuple.natural_32_item (i).to_natural_64)

					when {TUPLE}.Natural_64_code then
						l_count := natural_64_width (tuple.natural_64_item (i))

					when {TUPLE}.Pointer_code then
						l_count := 9

					when {TUPLE}.Reference_code then
						l_reference := tuple.reference_item (i)
						if attached {READABLE_STRING_GENERAL} l_reference as str then
							l_count := str.count
						elseif attached {EL_PATH} l_reference as path then
							l_count := path.parent_path.count + path.base.count + 1
						end

				else -- Double or real or something else
					l_count := 7
				end
				Result := Result + l_count
				i := i + 1
			end
		end

end
