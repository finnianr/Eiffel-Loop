note
	description: "Unique file identifier table indexed by owner field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	TL_UNIQUE_FILE_IDENTIFIER_FRAME_TABLE

inherit
	TL_FRAME_TABLE [TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME]
		rename
			cpp_find_frame as cpp_find_by_owner
		end

	TL_UNIQUE_FILE_IDENTIFIER_FRAME_CPP_API

end