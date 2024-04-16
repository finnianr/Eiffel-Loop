note
	description: "Appendable aspects of ${ZSTRING} that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 9:58:11 GMT (Monday 15th April 2024)"
	revision: "70"

deferred class
	EL_APPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION
		export
			{ANY} is_compatible, is_compatible_substring, Substitute
		end

	EL_MODULE_ENCODING
		export
			{ANY} Encoding
		end

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Append strings

	append_ascii (str: READABLE_STRING_8)
		require
			is_ascii: is_ascii_string (str)
		do
			append_string_8 (str)
		end

	append_compatible (latin_1: READABLE_STRING_8)
		-- append `latin_1' if all characters do not require encoding with `Codec' to be compatible
		require
			is_compatible: is_compatible (latin_1)
		do
			String_8.append_string_8 (Current, latin_1)
		end

	append_compatible_substring_8 (latin_1: READABLE_STRING_8; start_index, end_index: INTEGER)
		require
			compatible_substring: is_compatible_substring (latin_1, start_index, end_index)
		do
			append_substring_8 (latin_1, start_index, end_index)
		end

	append_encodeable (str: READABLE_STRING_8; str_encoding: EL_ENCODING_BASE)
		do
			if str_encoding.encoding = {EL_ENCODING_TYPE}.Other then
				append_encoded_any (str, str_encoding.as_encoding)

			elseif valid_encoding (str_encoding.encoding) then
				append_encoded (str, str_encoding.encoding)
			else
				append_string_8 (str)
			end
		end

	append_encoded_any (str: READABLE_STRING_8; str_encoding: ENCODING)
		-- append any `str' encoded with `str_encoding'
		do
			-- seems to be not possible to convert to `Codec.as_encoding' so using Unicode instead
			str_encoding.convert_to (Encodings.Unicode, str)
			if str_encoding.last_conversion_successful then
				check
					no_lost_data: not str_encoding.last_conversion_lost_data
				end
				append_string_general (str_encoding.last_converted_string)
			else
				append_string_8 (str)
			end
		end

	append_encoded (str: READABLE_STRING_8; str_encoding: NATURAL)
		-- append UTF, Latin, or Windows encoded `str'
		require
			valid_encoding: valid_encoding (str_encoding)
		local
			offset: INTEGER; u: UTF_CONVERTER; r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			-- UTF-16 must be first to test as it can look like ascii
			inspect str_encoding
				when {EL_ENCODING_TYPE}.Utf_16 then
					append_utf_16_le (str)

				when {EL_ENCODING_TYPE}.Utf_8 then
					append_utf_8 (str)

				when {EL_ENCODING_TYPE}.Mixed_utf_8_latin_1 then
					if u.is_valid_utf_8_string_8 (str) then
						append_utf_8 (str)
					else
						append_encoded (str, {EL_ENCODING_TYPE}.Latin_1)
					end
			else
				if codec.encoding = str_encoding then
					append_string_8 (str)

				elseif Codec_factory.valid_encoding (str_encoding)
					and then attached Codec_factory.codec_by (str_encoding) as l_codec
					and then attached Once_interval_list.emptied as unencoded_intervals
				then
					offset := count; accommodate (str.count)
					codec.re_encode_substring (l_codec, str, area, 1, str.count, offset, unencoded_intervals)
					if unencoded_intervals.count > 0 and then attached r.shared_cursor (str) as l_cursor then
						if has_mixed_encoding then
							append_unencoded_intervals (l_cursor, unencoded_intervals, offset)
						else
							make_from_intervals (l_cursor, unencoded_intervals, offset)
						end
						re_encode_intervals (l_codec, unencoded_intervals)
					end
				else
					append_string_8 (str)
				end
			end
		end

	append_from_right (str: EL_READABLE_ZSTRING; a_count: INTEGER)
		do
			if a_count >= str.count then
				append (str)

			else
				append_substring (str, str.count - a_count + 1, str.count)
			end
		end

	append_from_right_general (str: READABLE_STRING_GENERAL; a_count: INTEGER)
		do
			if a_count >= str.count then
				append_string_general (str)
			else
				append_substring_general (str, str.count - a_count + 1, str.count)
			end
		end

	append_replaced (str, old_substring, new_substring: EL_READABLE_ZSTRING)
		-- append `str' replacing any occurrences of `old_substring' with `new_substring'
		local
			i, start_index, end_index, size_difference: INTEGER
		do
			size_difference := new_substring.count - old_substring.count

			if attached Once_split_intervals as split_list then
				split_list.fill_by_string_general (str, old_substring, 0)
				if split_list.count > 0 and then attached empty_unencoded_buffer as buffer then
					if has_mixed_encoding then
						buffer.append (current_readable, 0)
					end
					grow (count + str.count + size_difference * (split_list.count - 1))
					if attached split_list.area as a then
						from until i = a.count loop
							start_index := a [i]; end_index := a [i + 1]
							if i > 0 then
								if new_substring.has_mixed_encoding then
									buffer.append (new_substring, count)
								end
								internal_append (new_substring, count)
							end
							if end_index >= start_index then
								if str.has_mixed_encoding then
									buffer.append_substring (str, start_index, end_index, count)
								end
								String_8.append_substring (Current, str, start_index, end_index)
							end
							i := i + 2
						end
					end
					set_unencoded_from_buffer (buffer)
				end
			end
		ensure
			valid_unencoded: is_valid
		end

	append_string_8 (str: READABLE_STRING_8)
		require else
			substitute_reserved: not str.has (Substitute)
		do
			String_8.append_string_8 (Current, str)
		end

	append_string, append (s: EL_READABLE_ZSTRING)
		local
			old_count: INTEGER
		do
			old_count := count
			internal_append (s, old_count)
			if s.has_mixed_encoding then
				append_unencoded (s, old_count)
			end
		ensure
			new_count: count = old count + s.count
			inserted: elks_checking implies same_string (old (current_readable + s))
		end

	append_string_general (general: READABLE_STRING_GENERAL)
		do
			append_string_general_for_type (general, Class_id.string_storage_type (general))
		end

	append_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER
		do
			old_count := count
			String_8.append_substring (Current, s, start_index, end_index)
			if s.has_unencoded_between_optimal (s.area, start_index, end_index)
				and then attached empty_unencoded_buffer as buffer
			then
				buffer.append_substring (s, start_index, end_index, old_count)
				if buffer.not_empty then
					append_unencoded (buffer, 0)
				end
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (current_readable + s.substring (start_index, end_index)))
		end

	append_substring_8 (str: READABLE_STRING_8; start_index, end_index: INTEGER)
		require else
			substitute_reserved: not str.substring (start_index, end_index).has (Substitute)
		do
			if attached current_string_8 as l_current then
				l_current.append_substring (str, start_index, end_index)
				set_from_string_8 (l_current)
			end
		end

	append_substring_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		require
			valid_end_index: end_index <= general.count
		local
			offset: INTEGER
		do
			if general.is_string_8 and then attached compatible_substring_8 (general, start_index, end_index) as str_8 then
				append_compatible_substring_8 (str_8, start_index, end_index)

			elseif same_type (general) then
				if attached {EL_READABLE_ZSTRING} general as z_str then
					append_substring (z_str, start_index, end_index)
				end
			else
				offset := count
				accommodate (end_index - start_index + 1)
				encode_substring (general, start_index, end_index, offset)
			end
		ensure
			unencoded_valid: is_valid
			appended: substring (old count + 1, count).same_string_general (general.substring (start_index, end_index))
		end

	append_utf_8 (utf_8_string: READABLE_STRING_8)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			internal_append_utf (utf_8_string, 8, utf_8.unicode_count (utf_8_string))
		end

	append_utf_16_le (utf_16_le_string: READABLE_STRING_8)
		local
			utf_16_le: EL_UTF_16_LE_CONVERTER
		do
			internal_append_utf (utf_16_le_string, 16, utf_16_le.unicode_count (utf_16_le_string))
		end

feature {STRING_HANDLER} -- Append character

	append_character, extend (uc: CHARACTER_32)
		do
			append_unicode (uc.natural_32_code)
		end

	append_unicode (uc: NATURAL)
			-- Append `uc' at end.
			-- It would be nice to make this routine over ride 'append_code' but unfortunately
			-- the post condition links it to 'code' and for performance reasons it is undesirable to have
			-- code return unicode.
		local
			l_count: INTEGER
		do
			l_count := count + 1
			if l_count > capacity then
				resize (l_count + additional_space)
			end
			set_count (l_count)
			put_unicode (uc, l_count)
		ensure then
			item_inserted: unicode (count) = uc
			new_count: count = old count + 1
			stable_before: elks_checking implies substring (1, count - 1) ~ (old current_readable)
		end

feature {STRING_HANDLER} -- Append integers

	append_integer, append_integer_32 (n: INTEGER)
		do
			if attached current_string_8 as l_current then
				l_current.append_integer (n)
				set_from_string_8 (l_current)
			end
		end

	append_integer_16 (n: INTEGER_16)
		do
			if attached current_string_8 as l_current then
				l_current.append_integer_16 (n)
				set_from_string_8 (l_current)
			end
		end

	append_integer_64 (n: INTEGER_64)
		do
			if attached current_string_8 as l_current then
				l_current.append_integer_64 (n)
				set_from_string_8 (l_current)
			end
		end

	append_integer_8 (n: INTEGER_8)
		do
			if attached current_string_8 as l_current then
				l_current.append_integer_8 (n)
				set_from_string_8 (l_current)
			end
		end

feature {STRING_HANDLER} -- Append naturals

	append_natural, append_natural_32 (n: NATURAL)
		do
			if attached current_string_8 as l_current then
				l_current.append_natural_32 (n)
				set_from_string_8 (l_current)
			end
		end

	append_natural_16 (n: NATURAL_16)
		do
			if attached current_string_8 as l_current then
				l_current.append_natural_16 (n)
				set_from_string_8 (l_current)
			end
		end

	append_natural_64 (n: NATURAL_64)
		do
			if attached current_string_8 as l_current then
				l_current.append_natural_64 (n)
				set_from_string_8 (l_current)
			end
		end

	append_natural_8 (n: NATURAL_8)
		do
			if attached current_string_8 as l_current then
				l_current.append_natural_8 (n)
				set_from_string_8 (l_current)
			end
		end

feature {STRING_HANDLER} -- Append general

	append_boolean (b: BOOLEAN)
		do
			if attached current_string_8 as l_current then
				l_current.append_boolean (b)
				set_from_string_8 (l_current)
			end
		end

feature {STRING_HANDLER} -- Append REAL

	append_real_32, append_real (n: REAL_32)
		do
			if attached current_string_8 as l_current then
				l_current.append_real (n)
				set_from_string_8 (l_current)
			end
		end

	append_real_64, append_double (n: REAL_64)
		do
			if attached current_string_8 as l_current then
				l_current.append_double (n)
				set_from_string_8 (l_current)
			end
		end

	append_rounded_double (n: REAL_64; place_count: INTEGER)
		-- append `n' rounded to `place_count' decimal places
		do
			if attached current_string_8 as l_current then
				l_current.append_integer_64 ((n * 10 ^ place_count).rounded_real_64.truncated_to_integer_64)
				l_current.insert_character ('.', l_current.count - place_count + 1)
				set_from_string_8 (l_current)
			end
		end

	append_rounded_real (n: REAL_32; place_count: INTEGER)
		-- append `n' rounded to `place_count' decimal places
		do
			append_rounded_double (n.to_double, place_count)
		end

feature {STRING_HANDLER} -- Contract support

	is_ascii_string (str: READABLE_STRING_8): BOOLEAN
		do
			Result := cursor_8 (str).all_ascii
		end

	is_ascii_substring (str: READABLE_STRING_8; start_index, end_index: INTEGER): BOOLEAN
		do
			Result := cursor_8 (str).is_ascii_substring (start_index, end_index)
		end

	valid_encoding (a_encoding: NATURAL): BOOLEAN
		-- `True' when `a_encoding' is `Mixed_utf_8_latin_1', UTF-8/16, Latin, or Windows
		do
			inspect a_encoding
				when {EL_ENCODING_TYPE}.Utf_16, {EL_ENCODING_TYPE}.Mixed_utf_8_latin_1 then
					Result := True
			else
				Result := Codec_factory.valid_encoding (a_encoding)
			end
		end

feature {NONE} -- Implementation

	accommodate (extra_count: INTEGER)
		local
			new_count: INTEGER
		do
			new_count := count + extra_count
			grow (count + extra_count)
			set_count (new_count)
		end

	append_string_general_for_type (general: READABLE_STRING_GENERAL; type_code: CHARACTER)
		require
			valid_type_code: valid_string_storage_type (type_code)
		local
			offset: INTEGER; convert_unicode: BOOLEAN
		do
			inspect type_code
				when '1' then
					if attached compatible_string_8 (general) as str_8 then
						append_compatible (str_8)
					else
						convert_unicode := True
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						append_string (zstr)
					end
			else
				convert_unicode := True
			end
			if convert_unicode then
				offset := count
				accommodate (general.count); encode (general, offset)
			end
		ensure
			unencoded_valid: is_valid
			appended: substring (old count + 1, count).same_string_general (general)
		end

	internal_append (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; old_count: INTEGER)
			-- Append characters of `s' at end.
		local
			new_count, s_count: INTEGER
		do
			s_count := s.count
			inspect s_count
				when 0 then
				-- do nothing
			else
				new_count := old_count + s_count
				if new_count > capacity then
					resize (new_count + additional_space)
				end
				area.copy_data (s.area, 0, old_count, s_count)
				set_count (new_count)
			end
		ensure
			new_count: count = old count + old s.count
			appended: elks_checking implies internal_string.same_string (old (internal_string + s.string))
		end

	internal_append_utf (utf_encoded_string: READABLE_STRING_8; utf_type, unicode_count: INTEGER)
		require
			valid_utf_type: utf_type = 8 or utf_type = 16
			valid_utf_16_input: utf_type = 16 implies utf_encoded_string.count \\ 2 = 0
		local
			offset: INTEGER; appended_as_ascii: BOOLEAN
		do
			inspect utf_type
				when 8 then
					if unicode_count = utf_encoded_string.count then
						append_ascii (utf_encoded_string)
						appended_as_ascii := True
					end
			else
			end
			if not appended_as_ascii and then attached empty_unencoded_buffer as buffer then
				offset := count; accommodate (unicode_count)
				codec.encode_utf (utf_encoded_string, area, utf_type, unicode_count, offset, buffer)
				if buffer.not_empty then
					append_unencoded (buffer, 0)
				end
			end
		end

end