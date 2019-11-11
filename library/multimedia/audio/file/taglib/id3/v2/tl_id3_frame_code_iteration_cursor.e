note
	description: "Tl id3 frame code iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 20:44:13 GMT (Monday 11th November 2019)"
	revision: "2"

class
	TL_ID3_FRAME_CODE_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [NATURAL_8]

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

	TL_SHARED_FRAME_ID_BYTES

create
	make

feature -- Access

	item: NATURAL_8
		do
			cpp_get_frame_id (self_ptr, Once_frame_id.self_ptr)
			Result := once_frame_id_enum
		end

end
