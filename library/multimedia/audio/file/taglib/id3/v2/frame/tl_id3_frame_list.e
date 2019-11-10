note
	description: "Tl id3 frame list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:44:34 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	TL_ID3_FRAME_LIST

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_FRAME_LIST_CPP_API

	ITERABLE [TL_ID3_TAG_FRAME]

create
	make

feature {NONE} -- Implementation

	new_cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			create Result.make (cpp_iterator_begin (self_ptr), cpp_iterator_end (self_ptr))
		end
end
