note
	description: "Document MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 14:49:35 GMT (Tuesday 10th April 2018)"
	revision: "5"

class
	EL_DOC_TYPE

create
	make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_latin_1 (a_type: STRING)
		do
			create encoding.make_latin_1
			type := a_type; specification := new_specification
		end

	make_utf_8 (a_type: STRING)
		do
			create encoding.make_utf_8
			type := a_type; specification := new_specification
		end

feature -- Access

	specification: STRING

	type: STRING

	encoding: EL_ENCODING

feature {NONE} -- Implementation

	new_specification: STRING
		do
			Result := Mime_type_template #$ [type, encoding.name]
		end

feature {NONE} -- Constants

	Mime_type_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end
end
