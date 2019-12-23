note
	description: "Shared frame ID enumeration codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 13:24:27 GMT (Sunday 22nd December 2019)"
	revision: "4"

deferred class
	TL_SHARED_FRAME_ID_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Frame_id: TL_FRAME_ID_ENUM
		once
			create Result.make
		end
end
