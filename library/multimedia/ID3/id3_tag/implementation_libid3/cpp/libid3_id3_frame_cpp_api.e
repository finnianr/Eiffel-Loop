note
	description: "Interface to class ID3_Frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "4"

class
	LIBID3_ID3_FRAME_CPP_API

inherit
	LIBID3_CPP_API

feature {LIBID3_FRAME_ITERATION_CURSOR} -- C++ Externals: ID3_Frame

	cpp_new (type_id: INTEGER): POINTER
			-- ID3_Frame::ID3_Frame (ID3_FrameID id = ID3FID_NOFRAME )
		external
			"C++ [new ID3_Frame %"id3/tag.h%"] (ID3_FrameID)"
		end

	cpp_id_number (self: POINTER): INTEGER
			--
		external
			"C++ [ID3_Frame %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetID"
		end

	frozen cpp_id (self: POINTER): POINTER
			-- const char* GetTextID() const
		external
			"C++ [ID3_Frame %"id3/tag.h%"]: EIF_POINTER"
		alias
			"GetTextID"
		end

	cpp_field_count (self: POINTER): INTEGER
			-- size_t NumFields() const;
		external
			"C++ [ID3_Frame %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"NumFields"
		end

	cpp_field_address (self: POINTER; field_id: INTEGER): POINTER
			-- ID3_Field* GetField(ID3_FieldID name)
		external
			"C++ [ID3_Frame %"id3/tag.h%"] (ID3_FieldID): EIF_POINTER"
		alias
			"GetField"
		end

	cpp_iterator (self: POINTER): POINTER
			--
		external
			"C++ [ID3_Frame %"id3/tag.h%"]: EIF_POINTER"
		alias
			"CreateIterator"
		end

end