note
	description: "Underbit id3 unique file id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_UNDERBIT_ID3_UNIQUE_FILE_ID

inherit
	EL_ID3_UNIQUE_FILE_ID
		export
			{NONE} all
			{ANY} Default_pointer
		undefine
			index_of_type, string, make_from_pointer
		end

	EL_UNDERBIT_ID3_FRAME
		rename
			code as field_id
		export
			{NONE} all
			{ANY} is_attached
		redefine
			make_from_pointer
		end

create
	make_from_pointer, make

feature -- Initialization

	make_from_pointer (obj_ptr: POINTER)
			--
		do
			Precursor {EL_UNDERBIT_ID3_FRAME} (obj_ptr)
		ensure then
			frame_is_unique_file_id: is_unique_file_id
		end

end