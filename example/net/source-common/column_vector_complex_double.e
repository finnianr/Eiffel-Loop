note
	description: "Summary description for {COLUMN_VECTOR_COMPLEX_DOUBLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-11 17:42:08 GMT (Wednesday 11th March 2015)"
	revision: "2"

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
