note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
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