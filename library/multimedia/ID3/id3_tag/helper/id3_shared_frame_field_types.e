note
	description: "Id3 field types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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