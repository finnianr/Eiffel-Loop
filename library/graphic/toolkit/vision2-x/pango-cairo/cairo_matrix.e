note
	description: "Cairo transformation matrix"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:54:20 GMT (Sunday 7th January 2024)"
	revision: "6"

class
	CAIRO_MATRIX

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_matrix
		export
			{EL_C_OBJECT} self_ptr
		end

	CAIRO_SHARED_API

create
	make_scaled

feature {NONE} -- Initialization

	make_scaled (scale_x, scale_y: DOUBLE)
		-- Initializes matrix to a transformation that scales by `scale_x', `scale_y'
		-- in the X and Y dimensions, respectively.
		do
			make_default
			Cairo.matrix_init_scale (self_ptr, 1 / scale_x, 1 / scale_y)
		end

feature {NONE} -- C Externals

	c_size_of_matrix: INTEGER
		external
			"C [macro <cairo.h>]"
		alias
			"sizeof (cairo_matrix_t)"
		end
end