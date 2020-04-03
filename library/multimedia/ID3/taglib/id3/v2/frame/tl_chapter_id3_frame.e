note
	description: "CHAPTER image ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 9:30:12 GMT (Saturday 14th March 2020)"
	revision: "3"

class
	TL_CHAPTER_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_CHAPTER_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

create
	make_from_pointer

feature -- Access

	start_time: NATURAL
		do
			Result := cpp_start_time (self_ptr)
		end
end
