note
	description: "Cairo source pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2020 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 9:33:13 GMT (Monday 13th July 2020)"
	revision: "1"

class
	EL_CAIRO_PATTERN

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_CAIRO_COMMAND_CONTEXT} self_ptr
		end

	EL_SHARED_CAIRO_API

	EV_ANY_HANDLER

	EL_CAIRO_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (surface: EL_CAIRO_SURFACE_I)
		do
			make_from_pointer (Cairo.new_pattern_for_surface (surface.self_ptr))
		end

feature -- Status change

	set_matrix (matrix: EL_CAIRO_MATRIX)
		-- set the transformation matrix to `matrix'
		do
			Cairo.set_pattern_matrix (self_ptr, matrix.self_ptr)
		end

	set_filter (a_filter: INTEGER)
		require
			valid_filter: is_valid_filter (a_filter)
		do
			Cairo.set_pattern_filter (self_ptr, a_filter)
		end

feature {EL_DRAWABLE_CAIRO_CONTEXT_I} -- Implementation

	c_free (this: POINTER)
		do
			Cairo.destroy_pattern (this)
		end

end
