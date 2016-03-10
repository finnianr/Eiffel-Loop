note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATLAB_COMPLEX_COLUMN_VECTOR_DOUBLE

inherit
	EL_MATLAB_COMPLEX_VECTOR_DOUBLE
		redefine
			imaginary
		end

create
	share_from_pointer, make, make_from_mx_pointer, make_from_complex_column_vector

feature {NONE} -- Initialization

	create_imaginary
			--
		do
			create imaginary.make (Current)
		end

feature -- Contract support

	is_orientation_valid (mx_matrix: POINTER): BOOLEAN
			--
		do
			Result := c_get_columns (mx_matrix)	= 1
		end

feature -- Conversion

	to_complex_column_vector: EL_COMPLEX_COLUMN_VECTOR [DOUBLE]
			--
		do
			create Result.make_from_pointer (
				area.to_c, imaginary.area.to_c, count, Double_bytes)
		end

feature -- Access

	imaginary: EL_MATLAB_IMAGINARY_COLUMN_VECTOR_DOUBLE

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
