note
	description: "[
		A reflected ${BOOLEAN} field representing set of two strings conforming to ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_BOOLEAN_REPRESENTATION [S -> READABLE_STRING_GENERAL]

inherit
	EL_STRING_FIELD_REPRESENTATION [BOOLEAN, S]

	EL_BOOLEAN_INDEXABLE [S]
		rename
			item as to_string
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (false_item, true_item: S)
		do
			Precursor (false_item, true_item)
			item := false_item
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- SPECIAL [" + ({S}).name + "]")
		end

feature -- Conversion

	to_value (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.same_caseless_characters (to_string (True), 1, to_string (True).count, 1)
		end

end