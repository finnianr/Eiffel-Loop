note
	description: "[
		Tag frame
		C++ memory managed by EL_IDTHREE_TAG owner
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 14:33:58 GMT (Friday 1st July 2016)"
	revision: "5"

class
	EL_LIBID3_FRAME

inherit
	EL_ID3_FRAME
		export
			{EL_LIBID3_TAG_INFO} self_ptr
		redefine
			make_from_pointer
		end

	EL_LIBID3_CONSTANTS
		export
			{NONE} all
		undefine
			out
		end

create
	make_from_pointer, make_with_code

feature {NONE} -- Initialization

	make_from_pointer (cpp_ptr: POINTER)
			--
		local
			field_iterator: EL_LIBID3_FIELD_ITERATOR
		do
--			log.enter ("make_from_pointer")
			Precursor (cpp_ptr)
			create field_list.make (field_count)
			create field_iterator.make (agent create_field_iterator)
			from field_iterator.start until field_iterator.after loop
--				log.put_string_field ("Type", field_iterator.item.type_name)
				if field_iterator.item.type = Type_encoding then
--					log.put_string_field (" Encoding", Encoding_names [field_iterator.item.integer])
				else
--					log.put_string_field (" Encoding", Encoding_names [field_iterator.item.encoding])
				end
				if field_iterator.item.type = Type_string_data then
--					log.put_string_field (" STRING", field_iterator.item.string)
				end
--				log.put_new_line
				field_list.extend (field_iterator.item)
				field_iterator.forth
			end
--			log.exit
		ensure then
			field_count_correct: field_list.count = field_count
		end

	make_with_code (a_code: STRING)
			--
		require else
			valid_id: Frame_id_table.has_key (a_code)
		do
			make_with_id (Frame_id_table [a_code])
		end

	make_with_id (type: INTEGER)
			--
		do
		   make_from_pointer (cpp_new (type))
		end

feature -- Access

	code: STRING
			--
		do
			create Result.make_from_c (cpp_id (self_ptr))
		end

	id_number: INTEGER
			--
		do
			Result := cpp_id_number (self_ptr)
		end

	field_count: INTEGER
			--
		do
			Result := cpp_field_count (self_ptr)
		end

	encoding: INTEGER
			--
		do
			if is_encodable then
				Result := libid3_encoding_to_standard (field_list.first.integer)
			else
				Result := Encoding_unknown
			end
		end

	field_list: FIXED_LIST [EL_LIBID3_FIELD]

feature -- Status query

	is_unique_file_id: BOOLEAN
			--
		do
			Result := id_number = Frame_id_table [Tag.Unique_file_ID]
		end

	has_text_field: BOOLEAN
			--
		local
			i: INTEGER
		do
			from i := 1 until i > field_list.count or Result = true loop
				if field_list.i_th (i).id = FN_text then
					Result := true
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	Field_type_binary_data: INTEGER
		do
			Result := FN_data
		end

	create_field_iterator: POINTER
			--
		do
			Result := cpp_iterator (self_ptr)
		end

	is_c_call_ok, is_field_changed: BOOLEAN

feature {NONE} -- C++ Externals: ID3_Frame

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

	cpp_id (self: POINTER): POINTER
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

feature {NONE} -- Externals

	c_is_single_byte_encoding (enc: INTEGER): BOOLEAN
			--
		external
			"C [macro %"id3/tag.h%"] (EIF_INTEGER): EIF_BOOLEAN"
		alias
			"ID3TE_IS_SINGLE_BYTE_ENC"
		end

end
