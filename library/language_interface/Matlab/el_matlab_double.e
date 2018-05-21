note
	description: "Matlab double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MATLAB_DOUBLE

inherit
	EL_MATLAB_VECTOR [DOUBLE]
		rename
			make as make_array
		redefine
			create_area, area
		end
create
	make

feature {NONE} -- Initialization

	make (value: DOUBLE)
		--
		do
			item := c_create_double_scalar (value)
			create_area
--			memory_monitor.allocate (Current, mx_count)
		end

feature -- Contract support

	is_orientation_valid (mx_array: POINTER): BOOLEAN
			--
		do
			Result := true
		end

feature {NONE} -- Unused

	create_matrix (size: INTEGER): POINTER
			--
		do
		end

feature {NONE} -- Implementation

	create_area
			--
		do
			count := 1
			create area.make (c_get_data (item), count)
		end

	area: EL_MEMORY_DOUBLE_ARRAY

	mx_count: INTEGER = 1

feature {NONE} -- C externals

	c_create_double_scalar (value: DOUBLE): POINTER
			-- Create scalar, double-precision array initialized to specified value

			-- mxArray *mxCreateDoubleScalar(double value)

		external
			"C (double): EIF_POINTER | <matrix.h>"
		alias
			"mxCreateDoubleScalar"
		end

end