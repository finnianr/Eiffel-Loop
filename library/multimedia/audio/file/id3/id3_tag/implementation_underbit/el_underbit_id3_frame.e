note
	description: "[
		Tag frame
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:19:33 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_UNDERBIT_ID3_FRAME

inherit
	EL_ID3_FRAME
		redefine
			string, make_from_pointer
		end

	EL_UNDERBIT_ID3_TAG_CONSTANTS
		undefine
			out
		end

	EL_UNDERBIT_C_API
		undefine
			out, dispose
		end

	EL_UNDERBIT_STRING_ROUTINES
		undefine
			dispose, out
		end

create
	make_from_pointer, make_with_code

feature {NONE} -- Initialization

	make_from_pointer (obj_ptr: POINTER)
			--
		local
			i: INTEGER
		do
			Precursor (obj_ptr)
			c_id3_frame_addref (self_ptr)

			create code.make_from_c (c_id3_frame_id (self_ptr))
			create field_list.make (field_count)
			from i := 1 until i > field_count loop
				field_list.extend (create_frame_field (i))
				i := i + 1
			end
		end

	make_with_code (a_code: STRING)
			--
		do
			make_from_pointer (c_id3_frame_new (a_code.area.base_address))
		end

feature -- Access

	code: STRING

	field_list: FIXED_LIST [EL_UNDERBIT_ID3_ENCODING_FIELD]

	encoding: INTEGER
			--
		do
			Result := encoding_field.encoding
		end

	encoding_field: EL_UNDERBIT_ID3_ENCODING_FIELD
			--
		do
			Result := field_list.first
		end

	string: ZSTRING
		do
			Result := Precursor
			if Result.is_integer and then code ~ Tag.Genre then
				Result := genre_string (Result.to_integer)
			end
		end

	field_count: INTEGER
			--
		do
			Result := c_id3_frame_nfields (self_ptr)
		end

feature -- Element change

--	set_encoding (new_encoding: INTEGER)
--			--
--		do
--			encoding_field.set_encoding (new_encoding)
--			set_string_field_encoding (new_encoding)
--		end

feature -- Status query

	is_unique_file_id: BOOLEAN
			--
		do
			Result := code ~ "UFID"
		end

feature {EL_UNDERBIT_ID3_TAG_INFO} -- Implementation

	create_frame_field (index: INTEGER): EL_UNDERBIT_ID3_ENCODING_FIELD
		local
			l_pointer: POINTER
		do
			l_pointer := c_id3_frame_field (self_ptr, index - 1)
			if index = 1 then
				create Result.make (l_pointer)
				if Result.type /= Type_encoding then
					create {EL_UNDERBIT_ID3_FIELD} Result.make (l_pointer)
				end

			elseif index = 2 and then code ~ Tag.User_text then
				create {EL_UNDERBIT_ID3_DESCRIPTION_FIELD} Result.make (l_pointer, encoding_field)

			elseif index = 3 and then code ~ Tag.Comment then
				create {EL_UNDERBIT_ID3_DESCRIPTION_FIELD} Result.make (l_pointer, encoding_field)

			elseif encoding_field.type = Type_encoding then
				create {EL_UNDERBIT_ID3_ENCODED_FIELD} Result.make (l_pointer, encoding_field)

			else
				create {EL_UNDERBIT_ID3_FIELD} Result.make (l_pointer)
			end
		end

--	set_string_field_encoding (new_encoding: INTEGER)
--		local
--			i: INTEGER
--		do
--			from i := 2 until i > field_list.count loop
--				if field_list.i_th (i).type = Type_string_data then
--					field_list.i_th (i).set_encoding (new_encoding)
--				end
--				i := i + 1
--			end
--		end

feature {NONE} -- Disposal

--	c_free (this: POINTER)
--			--
--		do
--			c_id3_frame_delref (self_ptr)
--			c_id3_frame_delete (self_ptr)
--		end

end