note
	description: "Prependable aspects of ${ZSTRING} that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 7:48:00 GMT (Sunday 25th August 2024)"
	revision: "60"

deferred class
	EL_PREPENDABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature {NONE} -- Prepend numeric

	prepend_boolean (b: BOOLEAN)
		do
			prepend_compatible (b.out)
		end

	prepend_integer, prepend_integer_32 (n: INTEGER)
		do
			prepend_compatible (n.out)
		end

	prepend_real_32, prepend_real (real_32: REAL_32)
		do
			prepend_compatible (real_32.out)
		end

	prepend_real_64, prepend_double (real_64: REAL_64)
		do
			prepend_compatible (real_64.out)
		end

feature {NONE} -- Prepend general

	prepend, prepend_string (s: EL_READABLE_ZSTRING)
		do
			insert_string (s, 1)
		ensure
			unencoded_valid: is_valid
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (s + current_readable))
		end

	prepend_string_general (general: READABLE_STRING_GENERAL)
		local
			type_code: CHARACTER; insert_adapted: BOOLEAN
		do
			type_code := string_storage_type (general)
			inspect type_code
				when '1' then
					if attached compatible_string_8 (general) as str_8 then
						prepend_compatible (str_8)
					else
						insert_adapted := True
					end
			else
				insert_adapted := True
			end
			if insert_adapted then
				insert_string (adapted_argument_for_type (general, type_code, 1), 1)
			end
		ensure then
			unencoded_valid: is_valid
		end

feature {NONE} -- Prepending

	precede, prepend_character (uc: CHARACTER_32)
		local
			c: CHARACTER
		do
			if uc.code <= Max_ascii_code then
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

	prepend_compatible (str: READABLE_STRING_8)
		require
			is_compatible_encoding: is_compatible (str)
		local
			old_count: INTEGER
		do
			old_count := count
			String_8.prepend (Current, str)
			if has_mixed_encoding then
				shift_unencoded (count - old_count)
			end
		end

	prepend_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			offset: INTEGER
		do
			String_8.prepend_substring (Current, s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					offset := end_index - start_index + 1
					if s.has_unencoded_between_optimal (s.area, start_index, end_index)
						and then attached empty_unencoded_buffer as buffer
					then
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
					if attached empty_unencoded_buffer as buffer then
						buffer.append_substring (s, start_index, end_index, 0)
						set_unencoded_from_buffer (buffer)
					end
			else
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (s.substring (start_index, end_index) + current_readable))
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

	insert_string (s: EL_READABLE_ZSTRING; i: INTEGER)
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		deferred
		ensure
			valid_unencoded: is_valid
			inserted: elks_checking implies (Current ~ (old substring (1, i - 1) + old (s.twin) + old substring (i, count)))
		end

end