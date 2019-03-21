note
	description: "Document MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-21 12:15:34 GMT (Thursday 21st March 2019)"
	revision: "6"

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

	encoding: EL_ENCODING

	specification: STRING

	type: STRING

feature -- Comparison

	same_as (other: EL_DOC_TYPE): BOOLEAN
		do
			Result := encoding.same_as (other.encoding) and type ~ other.type
		end

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
