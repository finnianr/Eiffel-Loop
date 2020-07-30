note
	description: "Unix implementation of [$source PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:43:09 GMT (Thursday 30th July 2020)"
	revision: "5"

class
	CAIRO_PANGO_CONTEXT_IMP

inherit
	CAIRO_PANGO_CONTEXT_I

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
