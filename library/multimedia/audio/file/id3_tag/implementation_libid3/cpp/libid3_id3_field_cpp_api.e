note
	description: "Interface to class ID3_Field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 13:34:24 GMT (Wednesday 30th October 2019)"
	revision: "2"

class
	LIBID3_ID3_FIELD_CPP_API

inherit
	LIBID3_CPP_API

feature {NONE} -- C++ Externals: ID3_Field Access

	cpp_is_encodable (self: POINTER): BOOLEAN
			-- bool IsEncodable()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_BOOLEAN"
		alias
			"IsEncodable"
		end

feature {LIBID3_FRAME_FIELD_ITERATION_CURSOR} -- C++ Externals: ID3_Field Access

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

	cpp_encoding (self: POINTER): INTEGER
			-- ID3_TextEnc ID3_Field::GetEncoding () const
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetEncoding"
		end

	cpp_fill_latin_buffer (self, buffer: POINTER; a_size: INTEGER): INTEGER
			-- size_t Get(char*, size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (char*, size_t): EIF_INTEGER"
		alias
			"Get"
		end

	cpp_fill_unicode_buffer (self, buffer: POINTER; a_size: INTEGER): INTEGER
			-- size_t Get(unicode_t *buffer, size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (unicode_t *, size_t): EIF_INTEGER"
		alias
			"Get"
		end

	cpp_integer (self: POINTER): INTEGER
			-- uint32 Get()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"Get"
		end

	cpp_size (self: POINTER): INTEGER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"Size"
		end

	cpp_text (self: POINTER): POINTER
			--
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetRawText"
		end

	cpp_text_item (self: POINTER; index: INTEGER): POINTER
			-- const char*   GetRawTextItem(size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (size_t): EIF_POINTER"
		alias
			"GetRawTextItem"
		end

	cpp_text_item_count (self: POINTER): INTEGER
			-- size_t GetNumTextItems()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetNumTextItems"
		end

	cpp_unicode_text (self: POINTER): POINTER
			--const unicode_t* GetRawUnicodeText()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetRawUnicodeText"
		end

	cpp_type (self: POINTER): INTEGER
			-- ID3_FieldType GetType()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetType"
		end

	cpp_unicode_text_item (self: POINTER; index: INTEGER): POINTER
			-- const unicode_t* GetRawUnicodeTextItem(size_t)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (size_t): POINTER"
		alias
			"GetRawUnicodeTextItem"
		end

	frozen cpp_id (self: POINTER): INTEGER
			-- ID3_FieldID   GetID()
		external
			"C++ [ID3_Field %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetID"
		end

feature {NONE} -- C++ Externals: ID3_Field Element change

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

	cpp_set_integer (self: POINTER; value: INTEGER)
			-- void Set(uint32)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (uint32)"
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

	cpp_set_text_unicode (self, unicode_ptr: POINTER): INTEGER
			-- size_t ID3_Field::Set (const unicode_t * data)
		external
			"C++ [ID3_Field %"id3/tag.h%"] (const unicode_t *): EIF_INTEGER"
		alias
			"Set"
		end

end
