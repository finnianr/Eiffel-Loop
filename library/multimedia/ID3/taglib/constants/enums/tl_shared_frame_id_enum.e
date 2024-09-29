note
	description: "Shared frame ID enumeration codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:48:14 GMT (Saturday 28th September 2024)"
	revision: "7"

deferred class
	TL_SHARED_FRAME_ID_ENUM

inherit
	EL_ANY_SHARED

feature -- Status query

	valid_frame_id (id: NATURAL_8): BOOLEAN
		do
			Result := Frame_id.valid_value (id)
		end

feature {NONE} -- Constants

	Frame_id: TL_FRAME_ID_ENUM
		once
			create Result.make
		end
end