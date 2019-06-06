note
	description: "Test values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 16:34:20 GMT (Thursday 6th June 2019)"
	revision: "1"

class
	TEST_VALUES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		end

create
	make

feature {NONE} -- Internal attributes

	double: DOUBLE

	integer: INTEGER

end
