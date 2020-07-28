note
	description: "Unix implementation of [$source EL_PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 9:23:43 GMT (Monday 13th July 2020)"
	revision: "3"

class
	EL_PANGO_CAIRO_CONTEXT_IMP

inherit
	EL_PANGO_CAIRO_CONTEXT_I

	EL_SHARED_IMAGE_UTILS_API

create
	make

feature {NONE} -- Implementation

	check_font_availability
		do
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EV_PIXMAP)
		local
			factor: DOUBLE
		do
			save
			if dimension = By_width then
				factor := a_size / a_pixmap.width
			else
				factor := a_size / a_pixmap.height
			end
			scale_by (factor)
			draw_pixmap ((x / factor).rounded, (y / factor).rounded, a_pixmap)
			restore
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
