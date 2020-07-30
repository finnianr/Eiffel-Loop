note
	description: "Windows implementation of [$source CAIRO_PANGO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:31:53 GMT (Thursday 30th July 2020)"
	revision: "5"

class
	CAIRO_PANGO_CONTEXT_IMP

inherit
	CAIRO_PANGO_CONTEXT_I
		redefine
			draw_scaled_pixel_buffer
		end

	EL_MODULE_SYSTEM_FONTS

	EL_MODULE_GDI_BITMAP

create
	make

feature {NONE} -- Implementation

	check_font_availability
		local
			substitute_fonts: like System_fonts.Substitute_fonts
		do
			substitute_fonts := System_fonts.Substitute_fonts
			substitute_fonts.search (font.name)
			if substitute_fonts.found then
				font.preferred_families.start
				font.preferred_families.replace (substitute_fonts.found_item.to_string_32)
			end
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, size: DOUBLE; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_scaled_buffer (dimension, buffer, size.rounded)
			draw_surface (x, y, l_surface)
			l_surface.destroy
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
