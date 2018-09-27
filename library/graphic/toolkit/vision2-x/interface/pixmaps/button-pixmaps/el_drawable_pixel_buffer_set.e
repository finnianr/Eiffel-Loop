note
	description: "Drawable pixel buffer set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_DRAWABLE_PIXEL_BUFFER_SET
inherit
	ANY
		redefine
			default_create
		end

create
	make, default_create

convert
	make ({EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET})

feature {NONE} -- Initialization

	default_create
		do
			create normal
			create depressed
			create highlighted
		end

	make (a_pixmap_set: EL_SVG_BUTTON_PIXMAP_SET)
		do
			create normal.make_with_path (a_pixmap_set.normal.png_output_path)
			create depressed.make_with_path (a_pixmap_set.depressed.png_output_path)
			create highlighted.make_with_path (a_pixmap_set.highlighted.png_output_path)
		end

feature -- Access

	normal: EL_DRAWABLE_PIXEL_BUFFER

	highlighted: like normal

	depressed: like normal

end