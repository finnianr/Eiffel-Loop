note
	description: "Summary description for {EL_LIBID3_FIELD_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:47:41 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EL_LIBID3_FIELD

inherit
	EL_ID3_FRAME_FIELD

	EL_LIBID3_CONSTANTS

	EL_ID3_FIELD_TYPES

	PLATFORM
		export
			{NONE} all
		end

create
	make_from_pointer

feature -- Access

	id: INTEGER
			--
		do
			Result := cpp_id (self_ptr)
		end

	encoding: INTEGER
			--
		do
			Result := libid3_encoding_to_standard (internal_encoding)
		end

	type: INTEGER
			--
		local
			l_type: INTEGER
		do
			l_type := cpp_type (self_ptr)
			if id = FN_text_encoding then
				Result := Type_encoding

			elseif id = FN_language then
				Result := Type_language

			elseif id = FN_description then
				Result := Type_description

			elseif l_type = Field_type_text_string then
				Result := Type_string_data

			elseif l_type = Field_type_binary then
				Result := Type_binary_data

			elseif l_type = Field_type_integer then
				Result := Type_integer

			end
		end

	string: ZSTRING
			--
		local
			l_encoding: INTEGER
		do
			l_encoding := encoding
			if l_encoding = Encoding_ISO_8859_1 then
				Result := text_latin1

			elseif l_encoding = Encoding_UTF_16 or l_encoding = Encoding_UTF_16_BE then
				-- A bit strange that only Big Endian decoding works
				Result := text_unicode

			elseif l_encoding = Encoding_UTF_8 then
				create Result.make_from_utf_8 (text_utf8)

			else
				Result := text_latin1

			end
		end

	binary_data: MANAGED_POINTER
			--
		do
			create Result.share_from_pointer (cpp_data (self_ptr), cpp_data_size (self_ptr))
		end

	integer: INTEGER
			--
		do
			Result := cpp_integer (self_ptr)
		end

feature -- Element change

	set_encoding (a_new_encoding: INTEGER)
			--
		local
			is_changed: BOOLEAN
			l_string: like string
		do
			if encoding /= a_new_encoding and then type = Type_string_data then
				l_string := string
				is_changed := cpp_set_encoding (self_ptr, standard_encoding_to_libid3 (a_new_encoding))
				if is_changed then
					set_string (l_string)
				end
			end
		end

	set_string (str: like string)
			--
		local
			l_encoding: INTEGER
		do
			l_encoding := encoding
			if l_encoding = Encoding_ISO_8859_1 then
				set_text_latin1 (str.to_latin_1)

			elseif l_encoding = Encoding_UTF_16 or l_encoding = Encoding_UTF_16_BE then
				-- A bit strange that only Big Endian works
				set_text_unicode (str.to_unicode)

			elseif l_encoding = Encoding_UTF_8 then
				set_text_utf8 (str.to_utf_8)

			else
				set_text_latin1 (str.to_latin_1)

			end
		end

	set_binary_data (data: MANAGED_POINTER)
			--
		do
			bytes_read := cpp_set_data (self_ptr, data.item, data.count)
		end

	set_data_integer (value: INTEGER)
			--
		do
			cpp_set_integer (self_ptr, value)
		end

feature {NONE} -- Implementation

	text_latin1, text_utf8: STRING
			--
		require
			valid_type: is_string
		do
			create Result.make_from_c (cpp_text (self_ptr))
		end

	text_unicode: STRING_32
			--
		require
			valid_type: is_string
		local
			c_string: EL_C_STRING_16_BE
		do
			create c_string.make (size // 2)
			create Result.make (c_string.count)
			characters_copied := cpp_fill_unicode_buffer (self_ptr, c_string.base_address, c_string.count)
			Result := c_string.as_string_32
		ensure
			valid_fill: characters_copied = Result.count
		end

	set_text_latin1, set_text_utf8 (str: STRING)
			--
		require
			valid_type: is_string
		do
			bytes_read := cpp_set_text (self_ptr, str.area.base_address)
		ensure
			is_set: bytes_read = str.count and str ~ text_latin1
		end

	set_text_unicode (str: STRING_32)
			--
		require
			valid_type: is_string
		local
			c_string: EL_C_STRING_16_BE
		do
			create c_string.make_from_string (str)
			bytes_read := cpp_set_text_unicode (self_ptr, c_string.base_address)
		ensure
			unicode_field_correct_size: bytes_read // 2 = str.count
			same_string: str ~ text_unicode
		end

	size: INTEGER
			--
		do
			Result := cpp_size (self_ptr)
		end

	data_size: INTEGER
			--
		do
			Result := cpp_data_size (self_ptr)
		end

	internal_encoding: INTEGER
			--
		do
			Result := cpp_encoding (self_ptr)
		end

	is_c_call_ok: BOOLEAN

	characters_copied, bytes_read: INTEGER

feature {NONE} -- C++ Externals: ID3_Field Access

	cpp_is_encodable (self: POINTER): BOOLEAN
			-- bool IsEncodable()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_BOOLEAN"
		alias
			"IsEncodable"
		end

feature {NONE} -- C++ Externals: ID3_Field Access

	cpp_id (self: POINTER): INTEGER
			-- ID3_FieldID   GetID()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetID"
		end

	cpp_integer (self: POINTER): INTEGER
			-- uint32 Get()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"Get"
		end

	cpp_text (self: POINTER): POINTER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetRawText"
		end

	cpp_text_unicode (self: POINTER): POINTER
			--const unicode_t* GetRawUnicodeText()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetRawUnicodeText"
		end

	cpp_fill_unicode_buffer (self, buffer: POINTER; a_size: INTEGER): INTEGER
			-- size_t Get(unicode_t *buffer, size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (unicode_t *, size_t): EIF_INTEGER"
		alias
			"Get"
		end

	cpp_data (self: POINTER): POINTER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetRawBinary"
		end

	cpp_data_size (self: POINTER): INTEGER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"BinSize"
		end

	cpp_size (self: POINTER): INTEGER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"Size"
		end

	cpp_encoding (self: POINTER): INTEGER
			-- ID3_TextEnc ID3_Field::GetEncoding () const
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetEncoding"
		end

	cpp_type (self: POINTER): INTEGER
			-- ID3_FieldType GetType()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetType"
		end

feature {NONE} -- C++ Externals: ID3_Field Element change

	cpp_set_integer (self: POINTER; value: INTEGER)
			-- void Set(uint32)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (uint32)"
		alias
			"Set"
		end

	cpp_set_text_unicode (self, unicode_ptr: POINTER): INTEGER
			-- size_t ID3_Field::Set (const unicode_t * data)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (const unicode_t *): EIF_INTEGER"
		alias
			"Set"
		end

	cpp_set_text (self, text_ptr: POINTER): INTEGER
			-- size_t ID3_Field::Set (const char * data )
		external
			"C++ [ID3_Field %"id3/tag.h%"] (const char *): EIF_INTEGER"
		alias
			"Set"
		end

	cpp_set_data (self, data_ptr: POINTER; count: INTEGER): INTEGER
			-- size_t Set(const uchar*, size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (const uchar*, size_t): EIF_INTEGER"
		alias
			"Set"
		end

	cpp_set_encoding (self: POINTER; an_encoding: INTEGER): BOOLEAN
			-- bool ID3_Field::SetEncoding (ID3_TextEnc enc)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (ID3_TextEnc): EIF_BOOLEAN"
		alias
			"SetEncoding"
		end

feature {NONE} -- Externals

	c_is_single_byte_encoding (enc: INTEGER): BOOLEAN
			--
		external
			"C [macro %"id3/tag.h%"] (EIF_INTEGER): EIF_BOOLEAN"
		alias
			"ID3TE_IS_SINGLE_BYTE_ENC"
		end

end