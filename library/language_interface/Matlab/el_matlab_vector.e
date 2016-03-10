note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_MATLAB_VECTOR [G]

inherit
	EL_MATLAB_C_TYPE

	EL_LOGGING

feature {NONE} -- Initialization

	make (max_index: INTEGER)
			--
		do
			item := create_matrix (max_index)
			create_area
--			memory_monitor.allocate (Current, mx_count)
		end

	share_from_pointer (mx_matrix: POINTER)
			-- Use directly `a_ptr' to hold current area.
		require
			valid_orientation: is_orientation_valid (mx_matrix)
		do
			item := mx_matrix
			is_shared := True
			create_area
		ensure
			is_shared_set: is_shared
		end

	make_from_mx_pointer (mx_matrix: POINTER)
			--
		require
			valid_orientation: is_orientation_valid (mx_matrix)
		do
			item := mx_matrix
--			memory_monitor.allocate (Current, mx_count)
			create_area
		end

feature -- Access

	count: INTEGER

	i_th (i: INTEGER): G
			--
		require
			i_in_range: i >= 1 and i <= count
		do
			Result := area.i_th (i)
		end

feature -- Element change

	put (value: G; i: INTEGER)
			--
		require
			i_in_range: i >= 1 and i <= count
		do
			area.put (value, i)
		end

	set_from_mx_pointer (mx_matrix: POINTER)
			--
		require
			valid_orientation: is_orientation_valid (mx_matrix)
		do
			dispose
			make_from_mx_pointer (mx_matrix)
		end

	set_from_array (an_array: ARRAY [G])
			--
		do
			if an_array.count /= count then
				resize (an_array.count)
			end
			area.copy_from_array (an_array)
		ensure
			count_matches_columns: count = mx_count
		end

feature -- Resizing

	resize (new_count: INTEGER)
			--
		do
			if new_count > count then
				dispose
				make (new_count)
			else
				count := new_count
				area.resize (new_count)
			end
		end

feature -- Conversion

	to_array: ARRAY [G]
			--
		local
			l_area: ANY
			l_area_ptr: POINTER
		do
			create Result.make (1, count)
			l_area := Result.to_c
			l_area_ptr := $l_area
			check
				area_big_enough: area.count = count
			end
			l_area_ptr.memory_copy (area.to_c, count * area.item_bytes)
		end

feature -- Contract support

	is_orientation_valid (mx_array: POINTER): BOOLEAN
			--
		deferred
		end

feature {EL_MATLAB_C_TYPE} -- Implementation

	create_area
			--
		require
			item_set: is_attached (item)
		deferred
		end

	create_matrix (size: INTEGER): POINTER
			--
		deferred
		end

	mx_count: INTEGER
			--
		require
			item_not_void: is_attached (item)
		deferred
		end

	is_shared: BOOLEAN
			-- Is `item' shared with another memory area?

	area: EL_MEMORY_ARRAY [G]

feature {NONE} -- Disposal

	dispose
			--
		do
			if not is_shared then
--				memory_monitor.free (Current, mx_count)
				c_destroy_array (item)
			end
		end

feature {NONE} -- Implementation

	memory_monitor: EL_MATLAB_MEMORY_MONITOR
			--
		once
			create Result
		end

feature {NONE} -- C externals: Memory management

	c_destroy_array (mx_array: POINTER)
			-- Dispose of string
			-- void mxDestroyArray(mxArray *pm);

		external
			"C (mxArray *) | <matrix.h>"
		alias
			"mxDestroyArray"
		end

	c_create_double_matrix (rows, cols: INTEGER): POINTER
			-- Create numeric array and initialize area elements to 0
			-- mxArray *mxCreateDoubleMatrix(int m, int n, mxComplexity flag);

		external
			"C inline use <matrix.h>"
		alias
			"mxCreateDoubleMatrix ((int) $rows,(int) $cols, mxREAL)"
		end

	c_free_data (data_ptr: POINTER)
			-- Dispose of array area
			-- void mxFree(void *ptr);

		external
			"C (void *) | <matrix.h>"
		alias
			"mxFree"
		end

feature {NONE} -- C externals: Getters

	c_get_dimensions (mx_array: POINTER): POINTER
			-- Pointer to array of sizes
			-- const int *mxGetDimensions(const mxArray *pa);

		external
			"C (const mxArray *): EIF_POINTER | <matrix.h>"
		alias
			"mxGetDimensions"
		end

	c_get_rows (mx_array: POINTER): INTEGER
			-- The number of rows in the mxArray to which pm points.
			-- size_t mxGetM(const mxArray *pm);

		external
			"C (const mxArray *): EIF_INTEGER | <matrix.h>"
		alias
			"mxGetM"
		end

	c_get_columns (mx_array: POINTER): INTEGER
			-- Number of columns in mx_array
			-- size_t mxGetN(const mxArray *pm);

		external
			"C (const mxArray *): EIF_INTEGER | <matrix.h>"
		alias
			"mxGetN"
		end

	c_get_data (mx_array: POINTER): POINTER
			-- Pointer to array of sizes
			-- void *mxGetData(const mxArray *pa);

		external
			"C (const mxArray *): EIF_POINTER | <matrix.h>"
		alias
			"mxGetData"
		end

	c_get_double_data (array: POINTER): POINTER
			-- The address of the first element of the real area
			-- double *mxGetPr(const mxArray *pm);

		external
			"C (const mxArray *): EIF_POINTER | <matrix.h>"
		alias
			"mxGetPr"
		end

feature {NONE} -- C externals: Setters

	c_set_columns (mx_array: POINTER; n: INTEGER)
			-- Sets the number of columns in the specified mxArray.
			-- void mxSetN(mxArray *array_ptr, int n);

		external
			"C (mxArray *, int *) | <matrix.h>"
		alias
			"mxSetN"
		end

	c_set_data (array, data_ptr: POINTER)
			-- Set array from area
			-- void mxSetData(mxArray *pm, void *pr);

		external
			"C (mxArray *, void *) | <matrix.h>"
		alias
			"mxSetData"
		end

invariant
	valid_instance: is_attached (item)

end
