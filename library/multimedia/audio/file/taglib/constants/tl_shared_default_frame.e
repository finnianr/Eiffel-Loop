note
	description: "Tl shared default frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 13:19:45 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_SHARED_DEFAULT_FRAME

feature {NONE} -- Constants

	Default_frame: TL_DEFAULT_ID3_TAG_FRAME
		once
			create Result.make
		end

end
