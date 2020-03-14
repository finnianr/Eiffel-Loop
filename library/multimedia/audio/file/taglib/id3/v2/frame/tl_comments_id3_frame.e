note
	description: "Tl comments id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 9:30:17 GMT (Saturday 14th March 2020)"
	revision: "4"

class
	TL_COMMENTS_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_COMMENTS_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_ONCE_STRING

create
	make_from_pointer

feature -- Access

	description: ZSTRING
		do
			cpp_get_description (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	language: STRING
		do
			cpp_get_language (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_string
		end

end
