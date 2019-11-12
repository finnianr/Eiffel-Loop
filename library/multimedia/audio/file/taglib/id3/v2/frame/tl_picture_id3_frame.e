note
	description: "Picture image ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 20:24:55 GMT (Tuesday 12th November 2019)"
	revision: "3"

class
	TL_PICTURE_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_PICTURE_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_ONCE_STRING

create
	make

feature -- Access

	picture: TL_BYTE_VECTOR
		do
			create Result.make (cpp_picture (self_ptr))
		end

	description: ZSTRING
		do
			cpp_get_description (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	mime_type: STRING
		do
			cpp_get_mime_type (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string_8
		end

end
