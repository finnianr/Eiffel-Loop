note
	description: "ID3 ver 2.x tag frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:54:15 GMT (Saturday 14th March 2020)"
	revision: "5"

class
	TL_ID3_TAG_FRAME

inherit
	EL_CPP_OBJECT
		export
			{TL_ID3_V2_TAG} self_ptr
		end

	TL_ID3_TAG_FRAME_CPP_API

	TL_SHARED_ONCE_STRING

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_FRAME_ID_ENUM

create
	make_from_pointer, default_create

feature -- Access

	id: STRING
		do
			if is_attached (self_ptr) then
				cpp_get_frame_id (self_ptr, Once_byte_vector.self_ptr)
				Result := Once_byte_vector.to_string_8
			else
				create Result.make_empty
			end
		end

	id_enum: NATURAL_8
		-- enumeration code for `id'
		do
			cpp_get_frame_id (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_frame_id_enum
		end

	text: ZSTRING
		do
			if is_attached (self_ptr) then
				cpp_get_string (self_ptr, Once_string.self_ptr)
				Result := Once_string.to_string
			else
				create Result.make_empty
			end
		end

end
