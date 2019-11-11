note
	description: "ID3 ver 2.x tag frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:19:36 GMT (Monday 11th November 2019)"
	revision: "3"

class
	TL_ID3_TAG_FRAME

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_TAG_FRAME_CPP_API

	TL_SHARED_ONCE_STRING

	TL_SHARED_FRAME_ID_BYTES

	TL_SHARED_FRAME_ID_ENUM

create
	make

feature -- Access

	id: STRING
		do
			cpp_get_frame_id (self_ptr, Once_frame_id.self_ptr)
			Result := Once_frame_id.to_string_8
		end

	id_enum: NATURAL_8
		-- enumeration code for `id'
		do
			cpp_get_frame_id (self_ptr, Once_frame_id.self_ptr)
			Result := once_frame_id_enum
		end

	text: ZSTRING
		do
			cpp_get_string (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

end
