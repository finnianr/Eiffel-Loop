note
	description: "Id3 field types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 12:14:01 GMT (Thursday   10th   October   2019)"
	revision: "6"

deferred class
	ID3_SHARED_FRAME_FIELD_TYPES

inherit
	EL_ANY_SHARED

feature -- Constants

	Field_type: ID3_FRAME_FIELD_TYPE_ENUM
		once
			create Result.make
		end

end
