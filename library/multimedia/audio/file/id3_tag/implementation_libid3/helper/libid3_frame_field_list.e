note
	description: "Libid3 frame field list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 13:27:36 GMT (Wednesday 30th October 2019)"
	revision: "1"

class
	LIBID3_FRAME_FIELD_LIST

inherit
	ITERABLE [LIBID3_FRAME_FIELD]

create
	make

feature {NONE} -- Initialization

	make (a_frame: LIBID3_FRAME; a_cpp_iterator: POINTER)
			--
		do
			frame := a_frame; cpp_iterator := a_cpp_iterator
		end

feature -- Access

	new_cursor: LIBID3_FRAME_FIELD_ITERATION_CURSOR
		do
			create Result.make (frame, cpp_iterator)
		end

feature {NONE} -- Internal attributes

	cpp_iterator: POINTER

	frame: LIBID3_FRAME

end
