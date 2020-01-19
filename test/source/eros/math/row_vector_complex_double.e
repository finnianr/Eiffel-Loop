note
	description: "Row vector from of [$source VECTOR_COMPLEX_DOUBLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 12:28:29 GMT (Sunday 19th January 2020)"
	revision: "6"

class
	ROW_VECTOR_COMPLEX_DOUBLE

inherit
	VECTOR_COMPLEX_DOUBLE
		rename
			make_default as make,
			make_row as make_with_size
		end

	EL_MAKEABLE undefine copy, is_equal, out end

create
	make, make_with_size, make_from_string, make_from_stream, make_from_binary_stream

feature -- Access

	count: INTEGER
			--
		do
			Result := width
		end

feature {NONE} -- Implementation

	element_name: STRING = "row"

	set_array_size_from_node
			--
		do
			make_matrix (1, node.to_integer)
		end

end
