note
	description: "Windows implementation of [$source EL_PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:04:36 GMT (Monday 13th July 2020)"
	revision: "3"

class
	EL_PANGO_CAIRO_CONTEXT_IMP

inherit
	EL_PANGO_CAIRO_CONTEXT_I
		redefine
			draw_scaled_pixel_buffer
		end

	EL_MODULE_SYSTEM_FONTS

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
		-- Using this pattern example to scale buffer
		-- https://cpp.hotexamples.com/examples
		-- /-/-/cairo_pattern_create_for_surface/cpp-cairo_pattern_create_for_surface-function-examples.html
		do
			buffer.lock
			if attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
				draw_scaled_surface (dimension, x, y, size, imp_buffer.cairo_context.surface)
			end
			buffer.unlock
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EL_PIXMAP)
		local
			scaled: EL_PIXMAP
		do
			create scaled.make_scaled_to_size (a_pixmap, dimension, a_size.rounded)
			draw_pixmap (x, y, scaled)
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
