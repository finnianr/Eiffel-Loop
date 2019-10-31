note
	description: "ID3 ver 2.x tag frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 13:00:15 GMT (Thursday   31st   October   2019)"
	revision: "2"

class
	TL_ID3_TAG_FRAME

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_TAG_FRAME_CPP_API

create
	make

feature -- Access

	id: TL_BYTE_VECTOR
		do
			create Result.make (cpp_frame_id (self_ptr))
		end

	text: TL_STRING
		do
			create Result.make (cpp_to_string (self_ptr))
		end

end
