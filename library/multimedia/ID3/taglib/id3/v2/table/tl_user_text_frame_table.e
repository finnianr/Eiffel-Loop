note
	description: "Table of user text frames indexed by description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 14:54:08 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_USER_TEXT_FRAME_TABLE

inherit
	TL_FRAME_TABLE [TL_USER_TEXT_IDENTIFICATION_ID3_FRAME]
		rename
			cpp_find_frame as cpp_user_find_text_frame
		end

	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API

end
