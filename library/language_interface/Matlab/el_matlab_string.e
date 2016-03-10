note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATLAB_STRING

inherit
	EL_MATLAB_VECTOR [CHARACTER]
		rename
			make as make_vector
		redefine
			create_area, area
		end

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		--
		local
			c_string: ANY
		do
			c_string := string.to_c
			item := c_create_string ($c_string)
		end

	create_area
			--
		do
			count := c_get_rows (item)
			create area.make (c_get_data (item), count)
		end

feature {NONE} -- Inapplicable

	create_matrix (size: INTEGER): POINTER
			--
		do
		end

feature -- Contract support

	is_orientation_valid (mx_array: POINTER): BOOLEAN
			--
		do
			Result := true
		end

feature {NONE} -- Implementation

	mx_count: INTEGER
			--
		do
		end

	area: EL_MEMORY_CHARACTER_ARRAY

feature {NONE} -- C externals

	c_create_string (string: POINTER): POINTER
			-- Create 1-by-N string mxArray initialized to specified string

		external
			"C (const char *): EIF_POINTER | <matrix.h>"
		alias
			"mxCreateString"
		end

end
