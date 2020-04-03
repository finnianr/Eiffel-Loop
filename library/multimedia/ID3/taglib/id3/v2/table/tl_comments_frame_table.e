note
	description: "Comments table indexed by description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 15:08:31 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_COMMENTS_FRAME_TABLE

inherit
	TL_FRAME_TABLE [TL_COMMENTS_ID3_FRAME]
		rename
			cpp_find_frame as cpp_find_by_description
		end

	TL_COMMENTS_ID3_FRAME_CPP_API

end
