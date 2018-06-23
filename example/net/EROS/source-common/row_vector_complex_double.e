note
	description: "Row vector complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	ROW_VECTOR_COMPLEX_DOUBLE

inherit
	E2X_VECTOR_COMPLEX_DOUBLE
		rename
			make as make_default,
			make_row as make
		end

create
	make, make_from_string

feature -- Access

	count: INTEGER
			--
		do
			Result := width
		end

feature {NONE} -- Implementation

	Vector_type: STRING = "row"

	set_array_size_from_node
			--
		do
			make_matrix (1, node.to_integer)
		end
		
end