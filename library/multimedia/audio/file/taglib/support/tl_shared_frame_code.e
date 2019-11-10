note
	description: "Tl shared frame code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:06:53 GMT (Sunday 10th November 2019)"
	revision: "1"

deferred class
	TL_SHARED_FRAME_CODE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Frame_code: TL_FRAME_CODE_ENUM
		once
			create Result.make
		end
end
