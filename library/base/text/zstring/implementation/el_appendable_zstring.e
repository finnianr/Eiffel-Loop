note
	description: "Appendable/Prependable aspects of [$source EL_ZSTRING] that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 9:38:49 GMT (Sunday 9th May 2021)"
	revision: "23"

deferred class
	EL_APPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION
		export
			{EL_READABLE_ZSTRING, STRING_HANDLER} Unencoded_character
		end

	EL_SHARED_UTF_8_ZCODEC

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Append strings

	append_ascii (str: READABLE_STRING_8)
		require
			is_ascii: is_ascii_string (str)
		do
			append_string_8 (str)
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
						internal_append_substring (str, previous_index, end_index)
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
					internal_append_substring (str, previous_index, end_index)
				end
				set_unencoded_from_buffer (buffer)
			end
		ensure
			valid_unencoded: is_valid
		end

	append_string_8 (str: READABLE_STRING_8)
		require else
			not_has_reserved_substitute_character: not str.has (Unencoded_character)
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
			old_count: INTEGER
		do
			if attached {EL_ZSTRING} general as str_z then
				append_string (str_z)

			elseif attached {READABLE_STRING_8} general as str_8 and then string_8.is_ascii (str_8) then
				append_ascii (str_8)
			else
				old_count := count
				grow (old_count + general.count)
				set_count (old_count + general.count)
				encode (general, old_count)
			end
		ensure then
			unencoded_valid: is_valid
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
					if attached tuple.reference_item (i) as ref_any then
						if attached {READABLE_STRING_GENERAL} ref_any as string then
							append_string_general (string)
						elseif attached {EL_PATH} ref_any as l_path then
							l_path.append_to (Current)
						elseif attached {PATH} ref_any as path then
							append_string_general (path.name)
						else
							append_string_general (ref_any.out)
						end
					end
			else
				internal_append_tuple_item (tuple, i)
			end
		end

	append_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER; buffer: like empty_unencoded_buffer
		do
			old_count := count
			internal_append_substring (s, start_index, end_index)
			if s.has_unencoded_between (start_index, end_index) then
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

	append_utf_8 (utf_8: READABLE_STRING_8)
		local
			conv: EL_UTF_CONVERTER
		do
			internal_append_utf_8 (utf_8, conv.unicode_count (utf_8))
		end

feature {NONE} -- Append character

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
				resize (l_count)
			end
			set_count (l_count)
			put_unicode (uc, l_count)
		ensure then
			item_inserted: unicode (count) = uc
			new_count: count = old count + 1
			stable_before: elks_checking implies substring (1, count - 1) ~ (old current_readable)
		end

feature {NONE} -- Append integers

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

feature {NONE} -- Append naturals

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

feature {NONE} -- Append general

	append_boolean (b: BOOLEAN)
		do
			if attached current_string_8 as l_current then
				l_current.append_boolean (b)
				set_from_string_8 (l_current)
			end
		end

feature {NONE} -- Append REAL

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

feature {NONE} -- Prepend numeric

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

feature {NONE} -- Prepend general

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

feature {EL_READABLE_ZSTRING} -- Prepending

	precede, prepend_character (uc: CHARACTER_32)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			internal_prepend_character (c)
			shift_unencoded (1)
			if c = Unencoded_character then
				put_unencoded_code (uc.natural_32_code, 1)
			end
		end

	prepend_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			offset: INTEGER; buffer: like empty_unencoded_buffer
		do
			internal_prepend_substring (s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					offset := end_index - start_index + 1
					if s.has_unencoded_between (start_index, end_index) then
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
			Result := string_8.is_ascii (str)
		end

feature {NONE} -- Implementation

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

	internal_append_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		do
			if attached current_string_8 as l_current then
				l_current.append_substring (string_8_argument (s, 1), start_index, end_index)
				set_from_string_8 (l_current)
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies
					internal_string.same_string (old (internal_string + s.substring (start_index, end_index)))
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

	internal_append_utf_8 (utf_8: READABLE_STRING_8; unicode_count: INTEGER)
		local
			old_count: INTEGER; buffer: like empty_unencoded_buffer
		do
			if unicode_count = utf_8.count then
				append_ascii (utf_8)
			else
				old_count := count
				grow (old_count + unicode_count)
				buffer := empty_unencoded_buffer
				codec.encode_utf_8 (utf_8, area, unicode_count, old_count, buffer)
				set_count (old_count + unicode_count)
				if buffer.not_empty then
					append_unencoded (buffer, 0)
				end
--				buffer.set_in_use (False)
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

	internal_prepend_character (c: CHARACTER_8)
			-- Add `c' at front.
		do
			if attached current_string_8 as l_current then
				l_current.prepend_character (c)
				set_from_string_8 (l_current)
			end
		ensure
			new_count: count = old count + 1
		end

	internal_prepend_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		do
			if attached current_string_8 as l_current then
				l_current.prepend_substring (string_8_argument (s, 1), start_index, end_index)
				set_from_string_8 (l_current)
			end
		ensure
			new_count: count = old count + end_index - start_index + 1
			prepended: elks_checking implies
				internal_string.same_string (old (s.substring (start_index, end_index) + internal_string))
		end

end