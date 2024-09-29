note
	description: "Picture image for ID3 ver 2.x frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:48:15 GMT (Saturday 28th September 2024)"
	revision: "10"

class
	TL_PICTURE_ID3_FRAME

inherit
	TL_DESCRIBEABLE_ID3_TAG_FRAME

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
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_picture: TL_ID3_PICTURE)
		-- make from `a_picture'
		-- This must be added to a tag inorder for the C++ object to be owned
		require
			valid_enum: Picture_type.valid_value (a_picture.type_enum)
		local
			l_data: like picture
		do
			make_from_pointer (cpp_new_empty)
			l_data := Once_byte_vector
			l_data.set_data (a_picture.data)
			set_picture (l_data)
			set_description (a_picture.description)
			set_mime_type (a_picture.mime_type)
			set_type_enum (a_picture.type_enum)
		end

feature -- Access

	mime_type: STRING
		do
			cpp_get_mime_type (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string_8
		end

	picture: TL_BYTE_VECTOR
		do
			create Result.make_from_pointer (cpp_picture (self_ptr))
		end

	type: STRING
		do
			Result := Picture_type.name (type_enum)
		end

	type_enum: NATURAL_8
		do
			Result := cpp_type_enum (self_ptr)
		ensure
			valid_type: Picture_type.valid_value (Result)
		end

feature -- Element change

	set_mime_type (a_mime_type: like mime_type)
		do
			Once_string.set_from_string (a_mime_type)
			cpp_set_mime_type (self_ptr, Once_string.self_ptr)
		ensure
			set: mime_type ~ a_mime_type
		end

	set_picture (a_picture: TL_BYTE_VECTOR)
		do
			cpp_set_picture (self_ptr, a_picture.self_ptr)
		ensure
			set: picture.checksum = a_picture.checksum
		end

	set_type_enum (a_type_enum: like type_enum)
		require
			valid_enum: Picture_type.valid_value (a_type_enum)
		do
			cpp_set_type (self_ptr, a_type_enum)
		ensure
			set: type_enum = a_type_enum
		end

end