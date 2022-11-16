note
	description: "Cairo transformation matrix"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	CAIRO_MATRIX

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_matrix
		export
			{CAIRO_API, CAIRO_SHARED_API} self_ptr
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