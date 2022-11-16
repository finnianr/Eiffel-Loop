note
	description: "Underbit id3 string routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	UNDERBIT_ID3_STRING_ROUTINES

inherit
	ID3_SHARED_ENCODING_ENUM

	UNDERBIT_ID3_C_API

feature {NONE} -- Implementation

	encoding: NATURAL_8
		deferred
		end

	string_at_address (ucs4_ptr: POINTER): ZSTRING
			--
		do
			if encoding = Encoding_enum.iso_8859_1 then
				Result := string_latin1 (ucs4_ptr)

			elseif encoding = Encoding_enum.UTF_8 then
				Result := string_utf8 (ucs4_ptr)

			elseif encoding = Encoding_enum.UTF_16 then
				Result := string_utf16 (ucs4_ptr)

			elseif encoding = Encoding_enum.UTF_16_BE then
				Result := string_utf16 (ucs4_ptr)
			else
				Result := "<Unknown encoding>"
			end
		end

	string_latin1 (ucs4_ptr: POINTER): ZSTRING
			--
		local
			latin1_ptr: POINTER
		do
			latin1_ptr := c_id3_ucs4_latin1duplicate (ucs4_ptr)
			create Result.make_from_latin_1_c (latin1_ptr)
			latin1_ptr.memory_free
		end

	string_utf8 (str_ptr: POINTER): ZSTRING
			--
		local
			utf8: EL_C_UTF8_STRING_8
		do
			create utf8.make_owned (c_id3_ucs4_utf8duplicate (str_ptr))
			Result := utf8.as_string
		end

	string_utf16 (str_ptr: POINTER): ZSTRING
			--
		local
			utf16_c_str: EL_C_STRING_16
			i: INTEGER
		do
			create utf16_c_str.make_owned (c_id3_ucs4_utf16duplicate (str_ptr))
			create Result.make (utf16_c_str.count)
			from i := 1 until i > utf16_c_str.count loop
				Result.append_unicode (utf16_c_str.item (i))
				i := i + 1
			end
		end

end