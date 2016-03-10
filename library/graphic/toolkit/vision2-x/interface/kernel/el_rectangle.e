note
	description: "Summary description for {EL_RECTANGLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "6"

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

	move_left_cms (offset_cms: REAL)
		do
			move (x - Screen.horizontal_pixels (offset_cms), y)
		end

	move_right_cms (offset_cms: REAL)
		do
			move (x + Screen.horizontal_pixels (offset_cms), y)
		end

	move_up_cms (offset_cms: REAL)
		do
			move (x, y - Screen.vertical_pixels (offset_cms))
		end

	move_down_cms (offset_cms: REAL)
		do
			move (x, y + Screen.vertical_pixels (offset_cms))
		end

feature -- Element change

	scale (proportion: REAL)
		do
			set_width ((width * proportion).rounded)
			set_height ((height * proportion).rounded)
		end

end
