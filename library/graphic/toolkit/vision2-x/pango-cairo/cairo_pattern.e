note
	description: "Cairo source pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:39:27 GMT (Thursday 30th July 2020)"
	revision: "3"

class
	CAIRO_PATTERN

inherit
	EL_OWNED_C_OBJECT
		export
			{CAIRO_COMMAND_CONTEXT} self_ptr
		end

	CAIRO_SHARED_API

	EV_ANY_HANDLER

	CAIRO_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (surface: CAIRO_SURFACE_I)
		do
			make_from_pointer (Cairo.new_pattern_for_surface (surface.self_ptr))
		end

feature -- Status change

	set_matrix (matrix: CAIRO_MATRIX)
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

feature {CAIRO_DRAWABLE_CONTEXT_I} -- Implementation

	c_free (this: POINTER)
		do
			Cairo.destroy_pattern (this)
		end

end
