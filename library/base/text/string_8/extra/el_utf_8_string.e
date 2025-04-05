note
	description: "String encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 18:36:56 GMT (Saturday 5th April 2025)"
	revision: "25"

class
	EL_UTF_8_STRING

inherit
	EL_STRING_8
		rename
			as_string_8 as as_latin_1,
			to_string_8 as to_latin_1,
			set as set_from
		end

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
			Result := buffer
			set_string (Result, True)
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_32 (keep_ref: BOOLEAN): STRING_32
		-- string with adjusted whitespace
		do
			Result := Buffer_32
			set_string_32 (Result, True)
			if keep_ref then
				Result := Result.twin
			end
		end

	adjusted_8 (keep_ref: BOOLEAN): STRING_8
		-- string with adjusted whitespace
		do
			Result := Buffer_8
			set_string_8 (Result, True)
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string (keep_ref: BOOLEAN): ZSTRING
		-- string with unadjusted whitespace
		do
			Result := Buffer
			set_string (Result, False)
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string_32 (keep_ref: BOOLEAN): STRING_32
		-- string with unadjusted whitespace
		do
			Result := Buffer_32
			set_string_32 (Result, False)
			if keep_ref then
				Result := Result.twin
			end
		end

	raw_string_8 (keep_ref: BOOLEAN): STRING_8
		-- string with unadjusted whitespace
		do
			Result := Buffer_8
			set_string_8 (Result, False)
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

	set (other: ZSTRING)
		-- set `other' from adjusted `Current' UTF-8 string
		do
			set_string (other, True)
		end

	set_8 (other: STRING_8)
		-- set `other' from adjusted `Current' UTF-8 string
		do
			set_string_8 (other, True)
		end

	set_32 (other: STRING_32)
		-- set `other' from adjusted `Current' UTF-8 string
		do
			set_string_32 (other, True)
		end

	set_string (zstr: ZSTRING; adjust_whitespace: BOOLEAN)
		do
			zstr.wipe_out
			append_to_string (zstr, space_adjusted (adjust_whitespace))
		end

	set_string_32 (str_32: STRING_32; adjust_whitespace: BOOLEAN)
		do
			str_32.wipe_out
			if attached space_adjusted (adjust_whitespace) as l_adjusted and then l_adjusted.count > 0 then
				if attached super_readable_8 (l_adjusted) as s8 then
					if s8.is_ascii then
						s8.append_to_string_32 (str_32)
					else
						append_utf_8_to_string_32 (l_adjusted, str_32)
					end
				end
			end
		end

	set_string_8 (str_8_out: STRING_8; adjust_whitespace: BOOLEAN)
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			str_8_out.wipe_out
			if attached space_adjusted (adjust_whitespace) as l_adjusted and then l_adjusted.count > 0
				and then attached sg.super_readable_8 (l_adjusted) as str
			then
				if str.is_ascii then
					str.append_to_string_8 (str_8_out)
				else
					append_utf_8_to_string_8 (l_adjusted, str_8_out)
				end
			end
		end

feature {NONE} -- Implementation

	append_to_string (zstr: ZSTRING; utf_8: READABLE_STRING_8)
		do
			zstr.append_utf_8 (utf_8)
		end

	append_utf_8_to_string_32 (utf_8_in: READABLE_STRING_8; str_32_out: STRING_32)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			utf_8.string_8_into_string_general (utf_8_in, str_32_out)
		end

	append_utf_8_to_string_8 (utf_8_in: READABLE_STRING_8; str_8_out: STRING)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			utf_8.string_8_into_string_general (utf_8_in, str_8_out)
		end

	space_adjusted (adjust_whitespace: BOOLEAN): READABLE_STRING_8
		do
			if adjust_whitespace and then has_padding then
				Immutable_8.set_adjusted_item (area, 0, count, {EL_SIDE}.Both)
				Result := Immutable_8.item
			else
				Result := Current
			end
		end

feature {NONE} -- Constants

	Buffer: ZSTRING
		once
			create Result.make_empty
		end

	Buffer_8: STRING_8
		once
			create Result.make_empty
		end

	Buffer_32: STRING_32
		once
			create Result.make_empty
		end

end