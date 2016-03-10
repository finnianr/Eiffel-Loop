note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

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
