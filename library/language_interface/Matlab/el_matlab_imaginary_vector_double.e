note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_MATLAB_IMAGINARY_VECTOR_DOUBLE

inherit
	EL_MATLAB_VECTOR [DOUBLE]
		rename
			make as make_of_size
		redefine
			area
		end

feature {NONE} -- Initialization

	make (a_parent: EL_MATLAB_VECTOR_DOUBLE)
			--
		do
			parent := a_parent
			if is_matrix_complex (parent.item) then
				share_from_pointer (parent.item)
			else
				make_of_size (parent.mx_count)
			end
		end

feature {EL_MATLAB_C_TYPE} -- Implementation

	is_orientation_valid (mx_array: POINTER): BOOLEAN
			--
		do
			Result := parent.is_orientation_valid (mx_array)
		end

	parent: EL_MATLAB_VECTOR_DOUBLE
		-- Real component

	create_area
			--
		do
			count := mx_count
			if is_matrix_complex (parent.item) then
				create area.make (c_get_imaginery_double_data (item), count)
			else
				create area.make (c_get_double_data (item), count)
			end
		end

	area: EL_MEMORY_DOUBLE_ARRAY

feature {NONE} -- Implementation

	is_matrix_complex (mx_matrix: POINTER): BOOLEAN
			--
		do
			Result := c_is_complex (mx_matrix) = 1
		end

feature -- C externals

	c_get_imaginery_double_data (array: POINTER): POINTER
			-- The address of the first element of the real area
			-- double *mxGetPr(const mxArray *pm);

		external
			"C (const mxArray *): EIF_POINTER | <matrix.h>"
		alias
			"mxGetPi"
		end

	c_is_complex (array: POINTER): INTEGER
			-- True if the given array contains complex data.

		external
			"C (const mxArray *): EIF_INTEGER | <matrix.h>"
		alias
			"mxIsComplex"
		end

end
