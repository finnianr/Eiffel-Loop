note
	description: "Unix implementation of ${CAIRO_SURFACE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	CAIRO_SURFACE_IMP

inherit
	CAIRO_SURFACE_I

	EL_SHARED_IMAGE_UTILS_API

	EL_UNIX_IMPLEMENTATION

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_png

end