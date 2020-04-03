note
	description: "Unique file identifier table indexed by owner field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 14:53:52 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_UNIQUE_FILE_IDENTIFIER_FRAME_TABLE

inherit
	TL_FRAME_TABLE [TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME]
		rename
			cpp_find_frame as cpp_find_by_owner
		end

	TL_UNIQUE_FILE_IDENTIFIER_FRAME_CPP_API

end
