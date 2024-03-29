note
	description: "Libid3 frame field list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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