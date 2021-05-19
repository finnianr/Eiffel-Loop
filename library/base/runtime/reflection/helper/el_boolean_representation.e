note
	description: "A reflected [$source BOOLEAN] field representing one of two [$source STRING_8] objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:43:01 GMT (Wednesday 19th May 2021)"
	revision: "1"

class
	EL_BOOLEAN_REPRESENTATION

inherit
	EL_STRING_REPRESENTATION [BOOLEAN, STRING]

	EL_BOOLEAN_INDEXABLE [STRING]
		rename
			item as to_string
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (false_item, true_item: STRING)
		do
			Precursor (false_item, true_item)
			item := false_item
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- SPECIAL [STRING]")
		end

	to_value (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.same_caseless_characters (to_string (True), 1, to_string (True).count, 1)
		end

end