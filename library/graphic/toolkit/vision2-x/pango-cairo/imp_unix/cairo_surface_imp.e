note
	description: "Unix implementation of [$source CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 1:19:38 GMT (Monday 3rd August 2020)"
	revision: "6"

class
	CAIRO_SURFACE_IMP

inherit
	CAIRO_SURFACE_I

	EL_SHARED_IMAGE_UTILS_API

	EL_OS_IMPLEMENTATION

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file

end
