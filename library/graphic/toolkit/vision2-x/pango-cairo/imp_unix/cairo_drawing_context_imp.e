note
	description: "Unix implementation of [$source CAIRO_DRAWING_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-04 13:30:19 GMT (Wednesday 4th October 2023)"
	revision: "9"

class
	CAIRO_DRAWING_CONTEXT_IMP

inherit
	CAIRO_DRAWING_CONTEXT_I

	EL_OS_IMPLEMENTATION

	EL_SHARED_IMAGE_UTILS_API

create
	make, make_with_svg_image, make_default

feature {NONE} -- Implementation

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end