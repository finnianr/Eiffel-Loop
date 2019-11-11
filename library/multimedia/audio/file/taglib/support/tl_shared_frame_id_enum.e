note
	description: "Shared frame ID enumeration codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 18:34:52 GMT (Monday 11th November 2019)"
	revision: "2"

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
