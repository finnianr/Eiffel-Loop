note
	description: "Id3 field types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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
