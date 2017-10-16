note
	description: "Summary description for {EL_LIBID3_UNIQUE_FILE_ID_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_LIBID3_UNIQUE_FILE_ID

inherit
	EL_ID3_UNIQUE_FILE_ID
		undefine
			make_from_pointer
		end

	EL_LIBID3_FRAME
		rename
			code as field_id
		redefine
			make_from_pointer
		end

	EL_LIBID3_CONSTANTS
		undefine
			out
		end

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make_from_pointer (obj_ptr: POINTER)
			--
		do
			Precursor {EL_LIBID3_FRAME} (obj_ptr)
		ensure then
			frame_is_unique_file_id: is_unique_file_id
		end

end