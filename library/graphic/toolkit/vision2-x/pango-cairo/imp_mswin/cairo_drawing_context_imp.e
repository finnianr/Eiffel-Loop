note
	description: "Windows implementation of [$source CAIRO_DRAWING_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	CAIRO_DRAWING_CONTEXT_IMP

inherit
	CAIRO_DRAWING_CONTEXT_I
		redefine
			draw_scaled_area
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_GDI_BITMAP

create
	make

feature {NONE} -- Implementation

	draw_scaled_area (dimension: NATURAL_8; x, y, size: DOUBLE; drawing: CAIRO_DRAWING_AREA)
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_scaled_area (dimension, drawing, size.rounded)
			draw_surface (x, y, l_surface)
			l_surface.destroy
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end