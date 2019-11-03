note
	description: "Libid3 unique file id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 14:10:32 GMT (Thursday 10th October 2019)"
	revision: "6"

class
	LIBID3_UNIQUE_FILE_ID_FRAME

inherit
	ID3_UNIQUE_FILE_ID_FRAME

	LIBID3_FRAME
		rename
			code as field_id
		redefine
			make_from_pointer
		end

	LIBID3_CONSTANTS

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make_from_pointer (obj_ptr: POINTER)
			--
		do
			Precursor {LIBID3_FRAME} (obj_ptr)
		ensure then
			frame_is_unique_file_id: is_unique_file_id
		end

end
