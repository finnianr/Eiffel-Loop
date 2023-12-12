note
	description: "Square point array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-12 11:09:29 GMT (Tuesday 12th December 2023)"
	revision: "4"

class
	EL_SQUARE_POINT_ARRAY

inherit
	EL_RECTANGLE_POINT_ARRAY
		rename
			make as make_rectangle
		end

create
	make

feature {NONE} -- Initialization

	make (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			make_rectangle
			set_from_point_angle (a_p0, angle, width)
		end

feature -- Element change

	set_from_point_angle (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			if attached area as p then
				p [0].copy (a_p0)
				set_point_on_circle (p [1], a_p0, angle, width)
				set_point_on_circle (p [2], p [1], angle + radians (90), width)
				set_point_on_circle (p [3], p [2], angle + radians (180), width)
			end
		end

end