note
	description: "Text identification ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 14:36:44 GMT (Tuesday 12th November 2019)"
	revision: "2"

class
	TL_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

create
	make

feature -- Access

	field_list: TL_STRING_LIST
		do
			create Result.make (cpp_field_list (self_ptr))
		end
end
