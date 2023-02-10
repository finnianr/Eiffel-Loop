note
	description: "Appendable/Prependable aspects of [$source ZSTRING] that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-10 14:20:47 GMT (Friday 10th February 2023)"
	revision: "43"

deferred class
	EL_APPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION
		export
			{EL_READABLE_ZSTRING, STRING_HANDLER} Substitute
		end

	EL_SHARED_UTF_8_ZCODEC

	EL_MODULE_ENCODING
		export
			{ANY} Encoding
		end

	EL_SHARED_ENCODINGS

	EL_SHARED_STRING_8_CURSOR

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Append strings

	append_any (object: detachable ANY)
		require
			is_attached: attached object
		do
			if attached {READABLE_STRING_GENERAL} object as string then
				append_string_general (string)

			elseif attached {EL_PATH} object as path then
				path.append_to (Current)

			elseif attached {EL_PATH_STEPS} object as steps then
				steps.append_to (Current)

			elseif attached {PATH} object as path then
				append_string_general (path.name)

			elseif attached object as obj then
				append_string_general (obj.out)
			end
		end

	append_ascii (str: READABLE_STRING_8)
		require
			is_ascii: is_ascii_string (str)
		do
			append_string_8 (str)
		end

	append_ascii_substring (str: READABLE_STRING_8; start_index, end_index: INTEGER)
		require
			is_ascii: is_ascii_substring (str, start_index, end_index)
		do
			append_substring_8 (str, start_index, end_index)
		end

	append_encodeable (str: READABLE_STRING_8; str_encoding: EL_ENCODING_BASE)
		do
			if str_encoding.encoding = {EL_ENCODING_CONSTANTS}.Other then
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
			offset: INTEGER; buffer: like empty_unencoded_buffer
			l_codec: EL_ZCODEC; u: UTF_CONVERTER
		do
			-- UTF-16 must be first to test as it can look like ascii
			if str_encoding = {EL_ENCODING_CONSTANTS}.Utf_16 then
				append_utf_16_le (str)

			elseif cursor_8 (str).all_ascii then
				-- <= 127 is all the same no matter which encoding
				append_ascii (str)

			elseif str_encoding = {EL_ENCODING_CONSTANTS}.Utf_8 then
				append_utf_8 (str)

			elseif str_encoding = {EL_ENCODING_CONSTANTS}.Mixed_utf_8_latin_1 then
				if u.is_valid_utf_8_string_8 (str) then
					append_utf_8 (str)
				else
					append_encoded (str, {EL_ENCODING_CONSTANTS}.Latin_1)
				end

			elseif codec.encoding = str_encoding then
				append_string_8 (str)

			elseif Codec_factory.valid_encoding (str_encoding) then
				l_codec := Codec_factory.codec_by (str_encoding)
				buffer := empty_unencoded_buffer
				offset := count; accommodate (str.count)
				if attached cursor_8 (str) as c then
					codec.re_encode (l_codec, c.area, area, str.count, c.area_first_index, offset, buffer)
					inspect respective_encoding (buffer)
						when Both_have_mixed_encoding then
							append_unencoded (buffer, 0)
						when Only_other then
							set_unencoded_from_buffer (buffer)
					else
					end
				end
			else
				append_string_8 (str)
			end
		end

	append_replaced (str, old_substring, new_substring: EL_READABLE_ZSTRING)
		-- append `str' replacing any occurrences of `old_substring' with `new_substring'
		local
			original_count, previous_index, end_index, new_count, size_difference: INTEGER
			positions: ARRAYED_LIST [INTEGER]; buffer: like empty_unencoded_buffer
		do
			original_count := old_substring.count
			positions := str.internal_substring_index_list (old_substring)
			if not positions.is_empty then
				buffer := empty_unencoded_buffer
				if has_mixed_encoding then
					buffer.append (current_readable, 0)
				end
				size_difference := new_substring.count - original_count
				new_count := count + str.count + (new_substring.count - original_count) * positions.count
				grow (new_count)
				previous_index := 1
				from positions.start until positions.after loop
					end_index := positions.item - 1
					if end_index >= previous_index then
						if str.has_mixed_encoding then
							buffer.append_substring (str, previous_index, end_index, count)
						end
						String_8.append_substring (Current, str, previous_index, end_index)
					end
					if new_substring.has_mixed_encoding then
						buffer.append (new_substring, count)
					end
					internal_append (new_substring)
					previous_index := positions.item + old_substring.count
					positions.forth
				end
				end_index := str.count
				if previous_index <= end_index then
					if str.has_mixed_encoding then
						buffer.append_substring (str, previous_index, end_index, count)
					end
					String_8.append_substring (Current, str, previous_index, end_index)
				end
				set_unencoded_from_buffer (buffer)
			end
		ensure
			valid_unencoded: is_valid
		end

	append_string_8 (str: READABLE_STRING_8)
		require else
			not_has_reserved_substitute_character: not str.has (Substitute)
		do
			if attached current_string_8 as l_current then
				l_current.append (str)
				set_from_string_8 (l_current)
			end
		end

	append_string, append (s: EL_READABLE_ZSTRING)
		local
			old_count: INTEGER
		do
			old_count := count
			internal_append (s)
			if s.has_mixed_encoding then
				append_unencoded (s, old_count)
			end
		ensure
			new_count: count = old count + s.count
			inserted: elks_checking implies same_string (old (current_readable + s))
		end

	append_string_general (general: READABLE_STRING_GENERAL)
		local
			offset: INTEGER
		do
			if attached {EL_ZSTRING} general as str_z then
				append_string (str_z)

			elseif attached {READABLE_STRING_8} general as str_8 and then cursor_8 (str_8).all_ascii then
				append_ascii (str_8)
			else
				offset := count
				accommodate (general.count)
				encode (general, offset)
			end
		ensure
			unencoded_valid: is_valid
			appended: substring (old count + 1, count).same_string_general (general)
		end

	append_tuple_item (tuple: TUPLE; i: INTEGER)
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Boolean_code then
					append_boolean (tuple.boolean_item (i))

				when {TUPLE}.Character_8_code then
					append_character (tuple.character_8_item (i))

				when {TUPLE}.Character_32_code then
					append_character (tuple.character_32_item (i))

				when {TUPLE}.Integer_8_code then
					append_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					append_integer_32 (tuple.integer_32_item (i))

				when {TUPLE}.Integer_64_code then
					append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					append_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					append_natural_16 (tuple.natural_16_item (i))

				when {TUPLE}.Natural_32_code then
					append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Real_32_code then
					append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					append_double (tuple.real_64_item (i))

				when {TUPLE}.Pointer_code then
					append_string_general (tuple.pointer_item (i).out)

				when {TUPLE}.Reference_code then
					append_any (tuple.reference_item (i))
			else
				internal_append_tuple_item (tuple, i)
			end
		end

	append_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER; buffer: like empty_unencoded_buffer
		do
			old_count := count
			String_8.append_substring (Current, s, start_index, end_index)
			if s.has_unencoded_between_optimal (s.area, start_index, end_index) then
				buffer := empty_unencoded_buffer
				buffer.append_substring (s, start_index, end_index, old_count)
				if buffer.not_empty then
					append_unencoded (buffer, 0)
				end
--				buffer.set_in_use (False)
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (current_readable + s.substring (start_index, end_index)))
		end

	append_substring_8 (str: READABLE_STRING_8; start_index, end_index: INTEGER)
		require else
			not_has_reserved_substitute_character: not str.substring (start_index, end_index).has (Substitute)
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
			if attached {EL_ZSTRING} general as str_z then
				append_substring (str_z, start_index, end_index)

			elseif attached {READABLE_STRING_8} general as str_8
				and then cursor_8 (str_8).is_ascii_substring (start_index, end_index)
			then
				append_ascii_substring (str_8, start_index, end_index)
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

feature {STRING_HANDLER} -- Prepend numeric

	prepend_boolean (b: BOOLEAN)
		do
			if attached current_string_8 as l_current then
				l_current.prepend_boolean (b)
				set_from_string_8 (l_current)
			end
		end

	prepend_integer, prepend_integer_32 (n: INTEGER)
		do
			if attached current_string_8 as l_current then
				l_current.prepend_integer (n)
				set_from_string_8 (l_current)
			end
		end

	prepend_real_32, prepend_real (n: REAL_32)
		do
			if attached current_string_8 as l_current then
				l_current.prepend_real (n)
				set_from_string_8 (l_current)
			end
		end

	prepend_real_64, prepend_double (n: REAL_64)
		do
			if attached current_string_8 as l_current then
				l_current.prepend_double (n)
				set_from_string_8 (l_current)
			end
		end

feature {STRING_HANDLER} -- Prepend general

	prepend, prepend_string (s: EL_READABLE_ZSTRING)
		do
			internal_prepend (s)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					make_joined (s, Current, s.count)
				when Only_current then
					shift_unencoded (s.count)
				when Only_other then
					unencoded_area := s.unencoded_area.twin
			else
			end
		ensure
			unencoded_valid: is_valid
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (s + current_readable))
		end

	prepend_string_general (str: READABLE_STRING_GENERAL)
		do
			prepend_string (adapted_argument (str, 1))
		ensure then
			unencoded_valid: is_valid
		end

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Prepending

	precede, prepend_character (uc: CHARACTER_32)
		local
			c: CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			String_8.prepend_character (Current, c)
			shift_unencoded (1)
			if c = Substitute then
				put_unencoded (uc, 1)
			end
		end

	prepend_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			offset: INTEGER; buffer: like empty_unencoded_buffer
		do
			String_8.prepend_substring (Current, s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					offset := end_index - start_index + 1
					if s.has_unencoded_between_optimal (s.area, start_index, end_index) then
						buffer := empty_unencoded_buffer
						buffer.append_substring (s, start_index, end_index, 0)
						if buffer.not_empty then
							buffer.append (Current, offset)
							set_unencoded_from_buffer (buffer)
						else
							shift_unencoded (offset)
--							buffer.set_in_use (False)
						end
					else
						shift_unencoded (offset)
					end
				when Only_current then
					shift_unencoded (end_index - start_index + 1)
				when Only_other then
					buffer := empty_unencoded_buffer
					buffer.append_substring (s, start_index, end_index, 0)
					set_unencoded_from_buffer (buffer)
			else
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (s.substring (start_index, end_index) + current_readable))
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
				when {EL_ENCODING_CONSTANTS}.Utf_16, {EL_ENCODING_CONSTANTS}.Mixed_utf_8_latin_1 then
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

	internal_append (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Append characters of `s' at end.
		local
			new_count: INTEGER
		do
			new_count := count + s.count
			resize (new_count)
			area.copy_data (s.area, 0, count, s.count)
			set_count (new_count)
		ensure
			new_count: count = old count + old s.count
			appended: elks_checking implies internal_string.same_string (old (internal_string + s.string))
		end

	internal_append_tuple_item (tuple: TUPLE; i: INTEGER)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Boolean_code then
					append_boolean (tuple.boolean_item (i))

				when {TUPLE}.Integer_8_code then
					append_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					append_integer (tuple.integer_item (i))

				when {TUPLE}.Integer_64_code then
					append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					append_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Natural_32_code then
					append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Real_32_code then
					append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					append_double (tuple.real_64_item (i))

			else
			end
		end

	internal_append_utf (utf_encoded_string: READABLE_STRING_8; utf_type, unicode_count: INTEGER)
		require
			valid_utf_type: utf_type = 8 or utf_type = 16
			valid_utf_16_input: utf_type = 16 implies utf_encoded_string.count \\ 2 = 0
		local
			offset: INTEGER; buffer: like empty_unencoded_buffer
		do
			if utf_type = 8 and then unicode_count = utf_encoded_string.count then
				append_ascii (utf_encoded_string)
			else
				offset := count; accommodate (unicode_count)
				buffer := empty_unencoded_buffer
				codec.encode_utf (utf_encoded_string, area, utf_type, unicode_count, offset, buffer)
				if buffer.not_empty then
					append_unencoded (buffer, 0)
				end
			end
		end

	internal_prepend (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Prepend characters of `s' at front.
		do
			internal_insert_string (s, 1)
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies internal_string.same_string (old (s.string + internal_string))
		end

end