note
	description: "Cairo transformation matrix"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CAIRO_MATRIX

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_matrix
		export
			{EL_CAIRO_API, EL_SHARED_CAIRO_API} self_ptr
		end

	EL_SHARED_CAIRO_API

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
