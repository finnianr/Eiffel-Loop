note
	description: "Id3 date field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-09 12:38:13 GMT (Wednesday 9th October 2019)"
	revision: "1"

deferred class
	ID3_DATE_FIELD

inherit
	ID3_LATIN_1_STRING_FIELD
		redefine
			type
		end

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.date
		end
end
