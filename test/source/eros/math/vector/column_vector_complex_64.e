note
	description: "Column vector form of ${VECTOR_COMPLEX_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	COLUMN_VECTOR_COMPLEX_64

inherit
	VECTOR_COMPLEX_64
		rename
			make_default as make,
			make_column as make_with_size
		end

	EL_MAKEABLE undefine copy, is_equal, out end

create
	make, make_with_size, make_from_string, make_from_stream, make_from_binary_stream

feature -- Access

	count: INTEGER
			--
		do
			Result := height
		end

feature {NONE} -- Implementation

	element_name: STRING = "col"

	set_array_size_from_node
			--
		do
			make_matrix (node.to_integer, 1)
		end

end