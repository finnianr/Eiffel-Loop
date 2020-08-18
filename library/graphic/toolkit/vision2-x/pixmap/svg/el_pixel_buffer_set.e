note
	description: "Drawable pixel buffer set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-18 19:29:37 GMT (Tuesday 18th August 2020)"
	revision: "12"

class
	EL_PIXEL_BUFFER_SET

inherit
	ANY
		redefine
			default_create
		end

	EL_BUTTON_CONSTANTS

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
			create normal.make_with_pixmap (a_pixmap_set.pixmap (Button_state.normal))
			create depressed.make_with_pixmap (a_pixmap_set.pixmap (Button_state.depressed))
			create highlighted.make_with_pixmap (a_pixmap_set.pixmap (Button_state.highlighted))
		end

feature -- Access

	normal: CAIRO_DRAWING_AREA

	highlighted: CAIRO_DRAWING_AREA

	depressed: CAIRO_DRAWING_AREA

end
