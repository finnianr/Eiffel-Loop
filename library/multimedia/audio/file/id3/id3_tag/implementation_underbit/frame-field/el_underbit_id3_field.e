note
	description: "Encoded field, normally of type string_data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_UNDERBIT_ID3_FIELD

inherit
	EL_UNDERBIT_ID3_ENCODING_FIELD
		redefine
			string, set_encoding, set_string, encoding
		end

create
	make

feature -- Access

	encoding: INTEGER
			--
		do
			Result := Encoding_unknown
		end

	string: ZSTRING
			--
		local
			l_type: INTEGER
		do
			l_type := field_type
			if l_type = Field_type_latin1 then
				create Result.make_from_latin_1_c (c_id3_field_getlatin1 (self_ptr))

			elseif l_type = field_type_full_latin1 then
				create Result.make_from_latin_1_c (c_id3_field_getfulllatin1 (self_ptr))

			elseif l_type = Field_type_list_string then
				if string_count >= 1 then
					Result := i_th_string (1)
				else
					create Result.make_empty
				end

			elseif l_type = Field_type_string then
				Result := string_at_address (c_id3_field_getstring (self_ptr))

			elseif l_type = Field_type_full_string then
				Result := string_at_address (c_id3_field_getfullstring (self_ptr))

			elseif l_type = Field_type_language or l_type = Field_type_frame_id then
				Result := immediate

			else
				create Result.make_empty
			end
		end

feature -- Access: Field_type_list_string

	string_count: INTEGER
			--
		require
			valid_type: field_type = Field_type_list_string
		do
			Result := c_id3_field_getnstrings (self_ptr)
		end

	i_th_string (i: INTEGER): STRING_32
			--
		require
			valid_index: i <= string_count
			valid_type: field_type = Field_type_list_string
		do
			Result := string_at_address (c_id3_field_getstrings (self_ptr, i - 1))
		end

feature -- Status query

	is_string_type: BOOLEAN
			--
		do
			Result := type = Type_string_data
		end

feature -- Element change

	set_string (str: like string)
			--
		local
			l_type: INTEGER
		do
			l_type := field_type
			if l_type = Field_type_latin1 then
				set_latin1_string (str.to_latin_1)

			elseif l_type = field_type_full_latin1 then
				set_full_latin1_string (str.to_latin_1)

			elseif l_type = Field_type_list_string then
				set_strings (<< str >>)

			elseif l_type = Field_type_string then
				c_call_status := c_id3_field_setstring (self_ptr, to_ucs4 (str).item)

			elseif l_type = Field_type_full_string then
				c_call_status := c_id3_field_setfullstring (self_ptr, to_ucs4 (str).item)

			end
		ensure then
			is_set: c_call_status = 0
		end

	set_latin1_string (str: STRING)
			--
		require
			valid_type: field_type = Field_type_latin1
			no_carraige_returns: str.occurrences ('%N') = 0
		do
			c_call_status := c_id3_field_setlatin1 (self_ptr, str.area.base_address)
		ensure
			is_set: c_call_status = 0
		end

	set_full_latin1_string (str: STRING)
			--
		require
			valid_type: field_type = field_type_full_latin1
		do
			c_call_status := c_id3_field_setfulllatin1 (self_ptr, str.area.base_address)
		ensure
			is_set: c_call_status = 0
		end

feature -- Element change: Field_type_list_string

	set_strings (string_array: ARRAY [ZSTRING])
			--
		require
			valid_type: field_type = Field_type_list_string
		local
			pointer_array: ARRAY [POINTER]
			ucs4_array: ARRAY [like to_ucs4]
			i: INTEGER
		do
			create pointer_array.make (1, string_array.count)
			create ucs4_array.make (1, string_array.count)
			from i := 1 until i > string_array.count loop
				ucs4_array [i] := to_ucs4 (string_array [i])
				pointer_array [i] := ucs4_array.item (i).item
				i := i + 1
			end
			c_call_status := c_id3_field_setstrings (self_ptr, pointer_array.count, pointer_array.area.base_address)
		ensure
			is_set: c_call_status = 0
		end

feature {NONE} -- Implementation

	set_encoding (new_encoding: INTEGER)
			-- Do nothng
		do
		end

	string_at_address (str_ptr: POINTER): ZSTRING
			--
		do
			if encoding = Encoding_ISO_8859_1 then
				Result := string_latin1 (str_ptr)

			elseif encoding = Encoding_UTF_8 then
				Result := string_utf8 (str_ptr)

			elseif encoding = Encoding_UTF_16 then
				Result := string_utf16 (str_ptr)

			elseif encoding = Encoding_UTF_16_BE then
				Result := string_utf16 (str_ptr)

			else
				create Result.make_empty

			end
		end

	string_latin1 (str_ptr: POINTER): ZSTRING
			--
		local
			latin1_ptr: POINTER
		do
			latin1_ptr := c_id3_ucs4_latin1duplicate (str_ptr)
			create Result.make_from_latin_1_c (latin1_ptr)
			latin1_ptr.memory_free
		end

	string_utf8 (str_ptr: POINTER): ZSTRING
			--
		local
			utf8: EL_C_UTF8_STRING_8
		do
			create utf8.make_owned (c_id3_ucs4_utf8duplicate (str_ptr))
			Result := utf8.as_string_32
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

	to_ucs4 (str: ZSTRING): EL_C_DATA
			--
		local
			l_area: SPECIAL [CHARACTER_8]; l_area_16: SPECIAL [NATURAL_16]
		do
			if encoding = Encoding_ISO_8859_1 then
				l_area := str.to_latin_1.area
				create Result.make_owned (c_id3_latin1_ucs4duplicate (l_area.base_address))

			elseif encoding = Encoding_UTF_8 then
				l_area := str.to_utf_8.area
				create Result.make_owned (c_id3_utf8_ucs4duplicate (l_area.base_address))

			elseif encoding = Encoding_UTF_16 or encoding = Encoding_UTF_16_BE then
				l_area_16 := UTF.string_32_to_utf_16_0 (str.to_unicode)
				create Result.make_owned (c_id3_utf16_ucs4duplicate (l_area_16.base_address))

			end
		end

	immediate: STRING
			--
		require
			immediate_type: field_type = Field_type_language or field_type = Field_type_frame_id
		do
			create Result.make_from_c (c_id3_field_value (self_ptr))
		end

end
