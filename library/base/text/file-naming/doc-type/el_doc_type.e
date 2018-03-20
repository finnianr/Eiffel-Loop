note
	description: "Document MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 11:37:11 GMT (Friday 2nd March 2018)"
	revision: "4"

class
	EL_DOC_TYPE

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make_utf_8 as make_utf_8_encodeable,
			make_latin_1 as make_latin_1_encodeable
		export
			{NONE} out
		end

create
	make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_latin_1 (a_type: STRING)
		do
			make_latin_1_encodeable
			type := a_type; specification := new_specification
		end

	make_utf_8 (a_type: STRING)
		do
			make_utf_8_encodeable
			type := a_type; specification := new_specification
		end

feature -- Access

	specification: STRING

	type: STRING

feature {NONE} -- Implementation

	new_specification: STRING
		do
			Result := Mime_type_template #$ [type, encoding_name]
		end

feature {NONE} -- Constants

	Mime_type_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end
end
