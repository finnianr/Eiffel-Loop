note
	description: "Test values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-07 9:32:16 GMT (Friday 7th June 2019)"
	revision: "2"

class
	TEST_VALUES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as export_default,
			element_node_type as	Attribute_node,
			register_default_values as do_nothing
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
