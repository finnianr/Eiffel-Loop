note
	description: "Unix implementation of [$source CAIRO_DRAWING_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 10:42:02 GMT (Monday 3rd August 2020)"
	revision: "7"

class
	CAIRO_DRAWING_CONTEXT_IMP

inherit
	CAIRO_DRAWING_CONTEXT_I

	EL_OS_IMPLEMENTATION

	EL_SHARED_IMAGE_UTILS_API

create
	make, make_with_svg_image

feature {NONE} -- Implementation

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
