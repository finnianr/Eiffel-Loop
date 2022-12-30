note
	description: "Test values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 11:01:22 GMT (Friday 30th December 2022)"
	revision: "8"

class
	TEST_VALUES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as Empty_set,
			field_included as is_any_field,
			xml_naming as eiffel_naming
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_double: like double; a_integer: like integer)
		do
			double := a_double; integer := a_integer
			make_default
		end

feature -- Element change

	set_double (a_double: like double)
		do
			double := a_double
		end

	set_integer (a_integer: like integer)
		do
			integer := a_integer
		end

feature -- Access

	double: DOUBLE

	integer: INTEGER

end