note
	description: "Test values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	TEST_VALUES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as Empty_set,
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