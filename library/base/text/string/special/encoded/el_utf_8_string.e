note
	description: "String encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-23 17:07:26 GMT (Friday 23rd June 2023)"
	revision: "12"

class
	EL_UTF_8_STRING

inherit
	EL_STRING_8
		rename
			as_string_8 as as_latin_1,
			to_string_8 as to_latin_1
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_MODULE_BUFFER_8

	EL_MODULE_BUFFER_32

	EL_MODULE_BUFFER

create
	make, make_filled, make_from_string

convert
	make_from_string ({STRING_8})

feature -- Measurement

	unicode_count: INTEGER
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := utf_8.unicode_count (Current)
		end

feature -- String conversion

	adjusted (keep_ref: BOOLEAN): ZSTRING
		-- string with adjusted whitespace
		do
			Result := buffer.empty
			set_string (Result, True)
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_32 (keep_ref: BOOLEAN): STRING_32
		-- string with adjusted whitespace
		local
			utf_8: EL_UTF_8_CONVERTER; start_index, end_index: INTEGER
		do
			end_index := count - trailing_white_count
			if end_index.to_boolean then
				start_index := leading_white_count + 1
			else
				start_index := 1
			end
			Result := buffer_32.empty
			if has_multi_byte_character then
				utf_8.substring_8_into_string_32 (Current, start_index, end_index, Result)
			else
				Result.append_substring_general (Current, start_index, end_index)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_8 (keep_ref: BOOLEAN): STRING_8
		-- string with adjusted whitespace
		local
			start_index, end_index: INTEGER
		do
			Result := buffer_8.empty
			if has_multi_byte_character then
				Result.append_string_general (adjusted_32 (False))
			else
				start_index := leading_white_count + 1
				end_index := count - trailing_white_count
				Result.append_substring (Current, start_index, end_index)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string (keep_ref: BOOLEAN): ZSTRING
		-- string with unadjusted whitespace
		do
			Result := buffer.empty
			Result.append_utf_8 (Current)
		end

	raw_string_32 (keep_ref: BOOLEAN): STRING_32
		-- string with unadjusted whitespace
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := buffer_32.empty
			if has_multi_byte_character then
				utf_8.string_8_into_string_32 (Current, Result)
			else
				Result.append_string_general (Current)
			end
		end

	raw_string_8 (keep_ref: BOOLEAN): STRING_8
		-- string with unadjusted whitespace
		do
			Result := buffer_8.empty
			if has_multi_byte_character then
				Result.append_string_general (raw_string_32 (False))
			else
				Result.append (Current)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	to_string: ZSTRING
		do
			Result := raw_string (True)
		end

	to_string_8, as_string_8: STRING_8
		do
			Result := raw_string_8 (True)
		end

feature -- Status query

	has_multi_byte_character: BOOLEAN
		do
			Result := not is_ascii
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

feature -- String setting

	set_string (zstr: ZSTRING; adjust_whitespace: BOOLEAN)
		local
			start_index, end_index, l_trimmed_count: INTEGER
		do
			zstr.wipe_out
			if trimmed_count ($start_index, $end_index, adjust_whitespace) > 0 then
				Immutable_8.set_item (area, start_index - 1, end_index - start_index + 1)
				append_to_string (zstr, Immutable_8.item)
			else
				append_to_string (zstr, Current)
			end
		end

	set_string_32 (str_32: STRING_32; adjust_whitespace: BOOLEAN)
		local
			start_index, end_index, l_trimmed_count: INTEGER
			utf_8: EL_UTF_8_CONVERTER
		do
			str_32.wipe_out
			l_trimmed_count := trimmed_count ($start_index, $end_index, adjust_whitespace)
			if has_multi_byte_character then
				append_to_string_32 (str_32, start_index, end_index)
			else
				str_32.append_substring_general (Current, start_index, end_index)
			end
			str_32.trim
		end

feature {NONE} -- Implementation

	trimmed_count (p_start_index, p_end_index: POINTER; adjust_whitespace: BOOLEAN): INTEGER
		local
			 start_index, end_index, trailing_count, leading_count: INTEGER
			 p: EL_POINTER_ROUTINES
		do
			start_index := 1; end_index := count
			if adjust_whitespace then
				trailing_count := trailing_white_count; leading_count := leading_white_count
				if leading_count > 0 or else trailing_count > 0 then
					start_index := start_index + leading_count
					end_index := end_index - trailing_count
					Result := trailing_count + leading_count
				end
			end
			p.put_integer_32 (start_index, p_start_index)
			p.put_integer_32 (end_index, p_end_index)
		end

	append_to_string (zstr: ZSTRING; utf_8: READABLE_STRING_8)
		do
			zstr.append_utf_8 (utf_8)
		end

	append_to_string_32 (str_32: STRING_32; start_index, end_index: INTEGER)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			utf_8.substring_8_into_string_32 (Current, start_index, end_index, str_32)
		end

end