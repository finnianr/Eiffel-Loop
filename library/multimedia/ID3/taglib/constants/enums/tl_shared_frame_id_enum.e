note
	description: "Shared frame ID enumeration codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 17:17:12 GMT (Tuesday 17th March 2020)"
	revision: "5"

deferred class
	TL_SHARED_FRAME_ID_ENUM

inherit
	EL_ANY_SHARED

feature -- Status query

	valid_frame_id (id: NATURAL_8): BOOLEAN
		do
			Result := Frame_id.is_valid_value (id)
		end

feature {NONE} -- Constants

	Frame_id: TL_FRAME_ID_ENUM
		once
			create Result.make
		end
end
