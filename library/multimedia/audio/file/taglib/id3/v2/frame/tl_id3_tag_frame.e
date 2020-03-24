note
	description: "ID3 ver 2.x tag frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-23 9:46:30 GMT (Monday 23rd March 2020)"
	revision: "8"

class
	TL_ID3_TAG_FRAME

inherit
	EL_CPP_OBJECT
		export
			{TL_ID3_V2_TAG_FRAME_ROUTINES} self_ptr
		end

	TL_ID3_TAG_FRAME_CPP_API

	TL_SHARED_ONCE_STRING

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_ONCE_STRING_LIST

create
	make_from_pointer

feature -- Access

	id: STRING
		do
			cpp_get_frame_id (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_string_8
		end

	id_enum: NATURAL_8
		-- enumeration code for `id'
		do
			cpp_get_frame_id (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_frame_id_enum
		end

	text: ZSTRING
		do
			cpp_get_string (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_text)
			cpp_set_text (self_ptr, Once_string.self_ptr)
		end

	set_integer_value (n: INTEGER)
		do
			Once_string.set_from_integer (n)
			cpp_set_text (self_ptr, Once_string.self_ptr)
		end

end
