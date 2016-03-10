note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_MATLAB_VECTOR_DOUBLE

inherit
	EL_MATLAB_VECTOR [DOUBLE]
		redefine
			create_area, area
		end

feature {NONE} -- Initialization

	create_area
			--
		do
			count := mx_count
			create area.make (c_get_double_data (item), count)
		end

feature {EL_MATLAB_C_TYPE} -- Implementation

	area: EL_MEMORY_DOUBLE_ARRAY

feature {NONE} -- C Externals

	c_numeric_array (dimensions: POINTER): POINTER
			-- Create numeric array and initialize area elements to 0
			-- mxArray *mxCreateNumericArray
			-- 					(int ndim, const int *dims, mxClassID classid, mxComplexity flag);

		external
			"C inline use <matrix.h>"
		alias
			"mxCreateNumericArray (1, (int*)$dimensions, mxDOUBLE_CLASS, mxREAL)"
		end

	c_set_double_data (array, double_array_ptr: POINTER)
			-- Set new real data for an mxArray
			-- void mxSetPr (mxArray *pm, void *pr);

		external
			"C (mxArray *, void *) | <matrix.h>"
		alias
			"mxSetPr"
		end


end
