note
	description: "Prependable aspects of [$source ZSTRING] that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-21 12:48:56 GMT (Tuesday 21st February 2023)"
	revision: "46"

deferred class
	EL_PREPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature {NONE} -- Prepend numeric

	prepend_boolean (b: BOOLEAN)
		do
			prepend_ascii (b.out)
		end

	prepend_integer, prepend_integer_32 (n: INTEGER)
		do
			prepend_ascii (n.out)
		end

	prepend_real_32, prepend_real (real_32: REAL_32)
		do
			prepend_ascii (real_32.out)
		end

	prepend_real_64, prepend_double (real_64: REAL_64)
		do
			prepend_ascii (real_64.out)
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
			if attached {READABLE_STRING_8} str as str_8
				and then str_8.count <= 50 and then is_ascii_string_8 (str_8)
			then
--				append small ASCII strings of <= 50 characters
				prepend_ascii (str_8)
			else
				prepend_string (adapted_argument (str, 1))
			end
		ensure then
			unencoded_valid: is_valid
		end

feature {NONE} -- Prepending

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
			offset: INTEGER; buffer: like Unencoded_buffer
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

	prepend_ascii (str: READABLE_STRING_8)
		require
			is_ascii: is_ascii_string_8 (str)
		local
			old_count: INTEGER
		do
			old_count := count
			String_8.prepend (Current, str)
			if has_mixed_encoding then
				shift_unencoded (old_count - count)
			end
		end

feature {NONE} -- Implementation

	internal_prepend (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Prepend characters of `s' at front.
		do
			internal_insert_string (s, 1)
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies internal_string.same_string (old (s.string + internal_string))
		end

end