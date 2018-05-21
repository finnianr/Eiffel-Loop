note
	description: "Column vector complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	COLUMN_VECTOR_COMPLEX_DOUBLE

inherit
	E2X_VECTOR_COMPLEX_DOUBLE
		rename
			make_default as make,
			make_column as make_with_size
		end

create
	make, make_with_size, make_from_string, make_from_stream, make_from_binary_stream

feature -- Access

	count: INTEGER
			--
		do
			Result := height
		end

feature {NONE} -- Implementation

	Vector_type: STRING = "col"

	set_array_size_from_node
			--
		do
			make_matrix (node.to_integer, 1)
		end

end
