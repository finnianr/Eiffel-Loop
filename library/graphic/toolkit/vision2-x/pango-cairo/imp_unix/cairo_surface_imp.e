note
	description: "Unix implementation of [$source CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 11:18:21 GMT (Sunday 2nd August 2020)"
	revision: "5"

class
	CAIRO_SURFACE_IMP

inherit
	CAIRO_SURFACE_I

	EL_SHARED_IMAGE_UTILS_API

	EL_OS_IMPLEMENTATION

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file

feature -- Factory

	new_drawable: CAIRO_PANGO_CONTEXT_I
		do
			create {CAIRO_PANGO_CONTEXT_IMP} Result.make (Current)
		end

end
