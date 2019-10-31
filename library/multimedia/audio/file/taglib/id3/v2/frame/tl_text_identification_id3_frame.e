note
	description: "Tl text identification id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 14:23:51 GMT (Thursday   31st   October   2019)"
	revision: "1"

class
	TL_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API

create
	make

feature -- Access

	field_list: TL_STRING_LIST
		do
			create Result.make (cpp_field_list (self_ptr))
		end
end
