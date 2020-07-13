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

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
