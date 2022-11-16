note
	description: "Matlab imaginary column vector double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_MATLAB_IMAGINARY_COLUMN_VECTOR_DOUBLE

inherit
	EL_MATLAB_IMAGINARY_VECTOR_DOUBLE

create
	make

feature {NONE} -- Implementation

	create_matrix (size: INTEGER): POINTER
			--
		do
			Result := c_create_double_matrix (size, 1)
		end

	mx_count: INTEGER
			--
		do
			Result := c_get_rows (item)
		end

end