note
	description: "Id3 description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-14 12:24:17 GMT (Monday   14th   October   2019)"
	revision: "1"

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
