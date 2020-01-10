note
	description: "Row vector from of [$source VECTOR_COMPLEX_DOUBLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 9:35:30 GMT (Friday 10th January 2020)"
	revision: "5"

class
	ROW_VECTOR_COMPLEX_DOUBLE

inherit
	VECTOR_COMPLEX_DOUBLE
		rename
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
