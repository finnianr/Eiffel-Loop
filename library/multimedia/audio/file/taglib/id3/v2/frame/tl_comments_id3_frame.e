note
	description: "Tl comments id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 13:44:43 GMT (Thursday   31st   October   2019)"
	revision: "1"

class
	TL_COMMENTS_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_COMMENTS_ID3_FRAME_CPP_API

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
