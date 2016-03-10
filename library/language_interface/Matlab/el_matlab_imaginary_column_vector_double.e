note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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
