note
	description: "Appendable/Prependable aspects of [$source EL_ZSTRING] that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-08 16:13:01 GMT (Wednesday 8th April 2020)"
	revision: "5"

deferred class
	EL_APPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature {EL_READABLE_ZSTRING} -- Append strings

	append_string, append (s: EL_READABLE_ZSTRING)
		local
			old_count: INTEGER
		do
			if s.has_mixed_encoding then
				old_count := count
				internal_append (s)
				append_unencoded (s.shifted_unencoded (old_count))
			else
				internal_append (s)
			end
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (current_readable + s))
		end

	append_string_general (str: READABLE_STRING_GENERAL)
		local
			old_count: INTEGER
		do
			if attached {EL_ZSTRING} str as str_z then
				append_string (str_z)
			else
				old_count := count
				grow (old_count + str.count)
				set_count (old_count + str.count)
				encode (str, old_count)
				reset_hash
			end
		ensure then
			unencoded_valid: is_unencoded_valid
		end

	append_tuple_item (tuple: TUPLE; i: INTEGER)
		local
			l_reference: ANY
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					append_character (tuple.character_8_item (i))

				when {TUPLE}.Character_32_code then
					append_character (tuple.character_32_item (i))

				when {TUPLE}.Pointer_code then
					append_string_general (tuple.pointer_item (i).out)

				when {TUPLE}.Reference_code then
					l_reference := tuple.reference_item (i)
					if attached {READABLE_STRING_GENERAL} l_reference as string then
						append_string_general (string)
					elseif attached {EL_PATH} l_reference as l_path then
						append_string (l_path.to_string)
					elseif attached {PATH} l_reference as path then
						append_string_general (path.name)
					else
						append_string_general (l_reference.out)
					end
			else
				internal_append_tuple_item (tuple, i)
			end
		end

	append_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER; l_unencoded: like unencoded_substring
		do
			old_count := count
			internal_append_substring (s, start_index, end_index)
			if s.has_mixed_encoding then
				l_unencoded := s.unencoded_substring (start_index, end_index)
				if l_unencoded.not_empty then
					l_unencoded.shift (old_count)
					append_unencoded (l_unencoded)
				end
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (current_readable + s.substring (start_index, end_index)))
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
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer (n)
			set_from_string_8 (str)
		end

	append_integer_16 (n: INTEGER_16)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_16 (n)
			set_from_string_8 (str)
		end

	append_integer_64 (n: INTEGER_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_64 (n)
			set_from_string_8 (str)
		end

	append_integer_8 (n: INTEGER_8)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_8 (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Append naturals

	append_natural, append_natural_32 (n: NATURAL)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_32 (n)
			set_from_string_8 (str)
		end

	append_natural_16 (n: NATURAL_16)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_16 (n)
			set_from_string_8 (str)
		end

	append_natural_64 (n: NATURAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_64 (n)
			set_from_string_8 (str)
		end

	append_natural_8 (n: NATURAL_8)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_8 (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Append general

	append_boolean (b: BOOLEAN)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_boolean (b)
			set_from_string_8 (str)
		end

feature {NONE} -- Append REAL

	append_real_32, append_real (n: REAL_32)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_real (n)
			set_from_string_8 (str)
		end

	append_real_64, append_double (n: REAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_double (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Prepend general

	prepend_boolean (b: BOOLEAN)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_boolean (b)
			set_from_string_8 (str)
		end

	prepend_integer, prepend_integer_32 (n: INTEGER)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_integer (n)
			set_from_string_8 (str)
		end

	prepend_real_32, prepend_real (n: REAL_32)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_real (n)
			set_from_string_8 (str)
		end

	prepend_real_64, prepend_double (n: REAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_double (n)
			set_from_string_8 (str)
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
			old_count: INTEGER; l_unencoded: like unencoded_substring
		do
			old_count := count
			internal_prepend_substring (s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					shift_unencoded (end_index - start_index + 1)
					l_unencoded := s.unencoded_substring (start_index, end_index)
					if l_unencoded.not_empty then
						l_unencoded.append (Current)
						unencoded_area := l_unencoded.area_copy
					end
				when Only_current then
					shift_unencoded (end_index - start_index + 1)
				when Only_other then
					l_unencoded := s.unencoded_substring (start_index, end_index)
					if l_unencoded.not_empty then
						unencoded_area := l_unencoded.area_copy
					end
			else
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (s.substring (start_index, end_index) + current_readable))
		end

feature {NONE} -- Implementation

	internal_append (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Append characters of `s' at end.
		local
			str: like current_string_8
		do
			str := current_string_8
			str.append (string_8_argument (s, 1))
			set_from_string_8 (str)
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
		local
			str: like current_string_8
		do
			str := current_string_8
			str.append_substring (string_8_argument (s, 1), start_index, end_index)
			set_from_string_8 (str)
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

	internal_prepend (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Prepend characters of `s' at front.
		require
			argument_not_void: s /= Void
		do
			internal_insert_string (s, 1)
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies internal_string.same_string (old (s.string + internal_string))
		end

	internal_prepend_character (c: CHARACTER_8)
			-- Add `c' at front.
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_character (c)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + 1
		end

	internal_prepend_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.prepend_substring (string_8_argument (s, 1), start_index, end_index)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + end_index - start_index + 1
			prepended: elks_checking implies
				internal_string.same_string (old (s.substring (start_index, end_index) + internal_string))
		end

end
