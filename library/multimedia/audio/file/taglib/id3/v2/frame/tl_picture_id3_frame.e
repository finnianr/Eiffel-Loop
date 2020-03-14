note
	description: "Picture image ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:50:22 GMT (Saturday 14th March 2020)"
	revision: "5"

class
	TL_PICTURE_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_PICTURE_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_ONCE_STRING

	TL_SHARED_PICTURE_TYPE_ENUM
		export
			{ANY} Picture_type
		end

	TL_SHARED_BYTE_VECTOR

create
	make, make_from_pointer, default_create

feature {NONE} -- Initialization

	make (data: MANAGED_POINTER; a_description: ZSTRING; a_mime_type: STRING; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
		local
			l_picture: like picture
		do
			make_from_pointer (cpp_new_empty)
			l_picture := Once_byte_vector
			l_picture.set_data (data)
			set_picture (l_picture)
			set_description (a_description)
			set_mime_type (a_mime_type)
			set_type_enum (a_type_enum)
		end

feature -- Access

	description: ZSTRING
		do
			if is_attached (self_ptr) then
				cpp_get_description (self_ptr, Once_string.self_ptr)
				Result := Once_string.to_string
			else
				create Result.make_empty
			end
		end

	mime_type: STRING
		do
			if is_attached (self_ptr) then
				cpp_get_mime_type (self_ptr, Once_string.self_ptr)
				Result := Once_string.to_string_8
			end
		end

	picture: TL_BYTE_VECTOR
		do
			if is_attached (self_ptr) then
				create Result.make_from_pointer (cpp_picture (self_ptr))
			end
		end

	type: STRING
		do
			Result := Picture_type.name (type_enum)
		end

	type_enum: NATURAL_8
		do
			if is_attached (self_ptr) then
				Result := cpp_type_enum (self_ptr)
			end
		ensure
			valid_type: Picture_type.is_valid_value (Result)
		end

feature -- Element change

	set_description (a_description: like description)
		local
			l_text: like Once_string
		do
			l_text.set_from_string (a_description)
			cpp_set_description (self_ptr, l_text.self_ptr)
		ensure
			set: description ~ a_description
		end

	set_mime_type (a_mime_type: like mime_type)
		local
			l_text: like Once_string
		do
			l_text.set_from_string_8 (a_mime_type)
			cpp_set_mime_type (self_ptr, l_text.self_ptr)
		end

	set_picture (a_picture: like picture)
		do
			cpp_set_picture (self_ptr, a_picture.item)
		ensure
			set: picture.checksum = a_picture.checksum
		end

	set_type_enum (a_type_enum: like type_enum)
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
		do
			cpp_set_type (self_ptr, a_type_enum)
		ensure
			set: type_enum = a_type_enum
		end

end
