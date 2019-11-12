note
	description: "Tl comments id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 14:36:24 GMT (Tuesday 12th November 2019)"
	revision: "2"

class
	TL_COMMENTS_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_COMMENTS_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

create
	make

feature -- Access

	description: TL_STRING
		do
			create Result.make (cpp_description (self_ptr))
		end

	language: TL_BYTE_VECTOR
		do
			create Result.make (cpp_language (self_ptr))
		end

end
