note
	description: "Rotatable rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:17:18 GMT (Monday 1st July 2019)"
	revision: "6"

class
	EL_ROTATABLE_RECTANGLE

inherit
	EV_MODEL_PARALLELOGRAM
		rename
			point_a_x as left,
			point_b_x as right,
			point_a_y as top,
			point_b_y as bottom
		end

	EL_MODULE_SCREEN

create
	make_rotated, make_rotated_cms

feature {NONE} -- Initialization

	make_rotated (a_width, a_height: INTEGER; a_angle: DOUBLE)
		do
			make_rectangle (0, 0, a_width, a_height)
			rotate_around (a_angle, 0, 0)
		end

	make_rotated_cms (width_cms, height_cms: REAL; a_angle: DOUBLE)
		do
			make_rotated (Screen.horizontal_pixels (width_cms), Screen.vertical_pixels (height_cms), a_angle)
		end

feature -- Basic operations

	draw (canvas: EL_DRAWABLE)
		local
			l_point_array: ARRAY [EV_COORDINATE]
		do
			create l_point_array.make_from_special (point_array)
			canvas.draw_polyline (l_point_array, True)
		end

feature -- Element change

	move (a_x, a_y: REAL)
		local
			transformation: EV_MODEL_TRANSFORMATION
		do
			create transformation.make_id
			transformation.translate (a_x, a_y)
			transform (transformation)
		end

end
