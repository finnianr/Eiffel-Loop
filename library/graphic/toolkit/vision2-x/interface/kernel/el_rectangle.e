note
	description: "Summary description for {EL_RECTANGLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-20 12:25:25 GMT (Friday 20th December 2013)"
	revision: "3"

class
	EL_RECTANGLE

inherit
	EV_RECTANGLE

	EL_MODULE_SCREEN
		undefine
			out
		end

create
	make, make_cms, make_for_text, make_for_pixmap

feature {NONE} -- Initialization

	make_cms (x_cms, y_cms, width_cms, height_cms: REAL)
		do
			make (
				Screen.horizontal_pixels (x_cms), Screen.vertical_pixels (y_cms),
				Screen.horizontal_pixels (width_cms), Screen.vertical_pixels (height_cms)
			)
		end

	make_for_text (a_text: READABLE_STRING_GENERAL; font: EV_FONT)
		do
			make (0, 0, font.string_width (a_text), font.line_height)
		end

	make_for_pixmap (a_pixmap: EV_PIXMAP)
		do
			make (0, 0, a_pixmap.width, a_pixmap.height)
		end

feature -- Basic operations

	move_center (other: EV_RECTANGLE)
			-- center on other
		do
			move (other.x + (other.width - width) // 2, other.y + (other.height - height) // 2)
		end

feature -- Element change

	scale (proportion: REAL)
		do
			set_width ((width * proportion).rounded)
			set_height ((height * proportion).rounded)
		end

end
