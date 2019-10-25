note
	description: "Underbit id3 unique file id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-14 13:49:25 GMT (Monday   14th   October   2019)"
	revision: "6"

class
	UNDERBIT_ID3_UNIQUE_FILE_ID_FRAME

inherit
	ID3_UNIQUE_FILE_ID_FRAME
		export
			{NONE} all
			{ANY} Default_pointer
		end

	UNDERBIT_ID3_FRAME
		rename
			make as make_frame,
			code as field_id
		export
			{NONE} all
			{ANY} is_attached
		redefine
			make_frame
		end

create
	make_frame, make

feature -- Initialization

	make_frame (obj_ptr: POINTER; a_code: STRING)
			--
		do
			Precursor {UNDERBIT_ID3_FRAME} (obj_ptr, a_code)
		ensure then
			frame_is_unique_file_id: is_unique_file_id
		end

end
