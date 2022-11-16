note
	description: "Tl id3 frame code iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	TL_ID3_FRAME_CODE_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [NATURAL_8]

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

	TL_SHARED_BYTE_VECTOR

create
	make

feature -- Access

	item: NATURAL_8
		do
			cpp_get_frame_id (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_frame_id_enum
		end

end