note
	description: "API pointers for SO elimageutils"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_IMAGE_UTILS_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS
		redefine
			function_names_with_upper
		end

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	convert_svg_to_png: POINTER

	format_argb_to_abgr: POINTER

	read_cairo_image: POINTER

	render_svg: POINTER

	rsvg_initialize: POINTER

	rsvg_new_image: POINTER

	rsvg_render_to_cairo: POINTER

	rsvg_set_dimensions: POINTER

	rsvg_terminate: POINTER

	save_cairo_image: POINTER

feature {NONE} -- Implementation

	function_names_with_upper: ARRAY [STRING]
		-- API functions names containing uppercase characters
		do
			Result := << "format_ARGB_to_ABGR" >>
		end

end
