note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_MATLAB_COMPLEX_VECTOR_DOUBLE

inherit
	EL_MATLAB_VECTOR_DOUBLE
		redefine
			c_create_double_matrix, make_from_mx_pointer, make
		end

feature {NONE} -- Initialization

	make (max_index: INTEGER)
			--
		do
			Precursor (max_index)
			create_imaginary
		end

	make_from_mx_pointer (mx_matrix: POINTER)
			--
		do
			Precursor (mx_matrix)
			create_imaginary
		end

	make_from_complex_column_vector (vector: EL_COMPLEX_COLUMN_VECTOR [DOUBLE])
			--
		do
			make (vector.count)
			set_from_array (vector)
			imaginary.set_from_array (vector.imaginary)
		end

	create_imaginary
			--
		deferred
		end

feature -- Element change

	set_from_complex_column_vector (complex_column_vector: EL_COMPLEX_COLUMN_VECTOR [DOUBLE])
			--
		do
			set_from_array (complex_column_vector)
			imaginary.set_from_array (complex_column_vector.imaginary)
		end

feature -- Access

	imaginary: EL_MATLAB_IMAGINARY_VECTOR_DOUBLE

feature {NONE} -- C Externals

	c_create_double_matrix (rows, cols: INTEGER): POINTER
			-- Create numeric array and initialize area elements to 0
			-- mxArray *mxCreateDoubleMatrix(int m, int n, mxComplexity flag);

		external
			"C inline use <matrix.h>"
		alias
			"mxCreateDoubleMatrix ((int) $rows,(int) $cols, mxCOMPLEX)"
		end

end
