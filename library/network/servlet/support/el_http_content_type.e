note
	description: "Summary description for {EL_HTTP_CONTENT_TYPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-30 13:29:49 GMT (Saturday 30th January 2016)"
	revision: "7"

class
	EL_HTTP_CONTENT_TYPE

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make_utf_8 as make_encodeable_utf_8,
			make_latin_1 as make_encodeable_latin_1
		redefine
			out
		end

create
	make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_utf_8 (a_type: STRING)
		do
			make_encodeable_utf_8
			type := a_type
		end

	make_latin_1 (a_type: STRING)
		do
			make_encodeable_latin_1
			type := a_type
		end
feature -- Access

	type: STRING

	out: STRING
		do
			Result := Mime_type_template #$ [type, encoding_name]
		end

feature {NONE} -- Constants

	Mime_type_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end
end