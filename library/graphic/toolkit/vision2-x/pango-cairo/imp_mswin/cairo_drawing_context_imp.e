note
	description: "Windows implementation of ${CAIRO_DRAWING_CONTEXT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "15"

class
	CAIRO_DRAWING_CONTEXT_IMP

inherit
	CAIRO_DRAWING_CONTEXT_I
		redefine
			draw_scaled_area
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_GDI_BITMAP

create
	make, make_default

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