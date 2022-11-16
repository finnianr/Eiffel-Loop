note
	description: "Id3 description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	ID3_DESCRIPTION_FIELD

inherit
	ID3_STRING_FIELD
		redefine
			type
		end

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.description
		end
end