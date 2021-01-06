note
	description: "String encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 17:03:29 GMT (Wednesday 6th January 2021)"
	revision: "4"

class
	EL_UTF_8_STRING

inherit
	EL_STRING_8

	EL_SHARED_ONCE_STRING_8

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_ZSTRING

create
	make

feature -- Access

	adjusted (keep_ref: BOOLEAN): ZSTRING
		local
			c: EL_UTF_CONVERTER; s: EL_STRING_8_ROUTINES
			n, start_index, end_index: INTEGER; str_32: STRING_32
		do
			start_index := s.leading_white_count (Current) + 1
			end_index := count - s.trailing_white_count (Current)
			Result := once_empty_string
			if has_multi_byte_character then
				str_32 := once_empty_string_32
				c.utf_8_substring_8_into_string_32 (Current, start_index, end_index, str_32)
				Result.append_string_general (str_32)
			else
				n := end_index - start_index + 1
				Result.grow (n)
				Result.area.copy_data (area, start_index - 1, 0, n)
				Result.set_count (n)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_8 (keep_ref: BOOLEAN): STRING_8
		local
			s: EL_STRING_8_ROUTINES; start_index, end_index: INTEGER
		do
			Result := once_empty_string_8
			if has_multi_byte_character then
				Result.append_string_general (adjusted_32 (False))
			else
				start_index := s.leading_white_count (Current) + 1
				end_index := count - s.trailing_white_count (Current)
				Result.append_substring (Current, start_index, end_index)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_32 (keep_ref: BOOLEAN): STRING_32
		local
			c: EL_UTF_CONVERTER; s: EL_STRING_8_ROUTINES
			start_index, end_index: INTEGER
		do
			start_index := s.leading_white_count (Current) + 1
			end_index := count - s.trailing_white_count (Current)
			Result := once_empty_string_32
			if has_multi_byte_character then
				c.utf_8_substring_8_into_string_32 (Current, start_index, end_index, Result)
			else
				Result.append_substring_general (Current, start_index, end_index)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string (keep_ref: BOOLEAN): ZSTRING
		do
			Result := once_empty_string
			Result.append_utf_8 (Current)
		end

	raw_string_8 (keep_ref: BOOLEAN): STRING_8
		do
			Result := once_empty_string_8
			if has_multi_byte_character then
				Result.append_string_general (raw_string_32 (False))
			else
				Result.append (Current)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string_32 (keep_ref: BOOLEAN): STRING_32
		local
			c: EL_UTF_CONVERTER
		do
			Result := once_empty_string_32
			if has_multi_byte_character then
				c.utf_8_string_8_into_string_32 (Current, Result)
			else
				Result.append_string_general (Current)
			end
		end

feature -- Status query

	has_multi_byte_character: BOOLEAN
		do
			Result := not is_7_bit
		end

feature -- Element change

	set_from_general (str: READABLE_STRING_GENERAL)
		local
			c: EL_UTF_CONVERTER
		do
			wipe_out
			grow (str.count)
			if attached {ZSTRING} str as zstr then
				zstr.append_to_utf_8 (Current)
			else
				c.utf_32_string_into_utf_8_string_8 (str, Current)
			end
		end

end