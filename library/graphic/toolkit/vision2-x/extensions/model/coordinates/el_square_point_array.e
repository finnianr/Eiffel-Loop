note
	description: "Square point array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-07 15:24:57 GMT (Sunday 7th June 2020)"
	revision: "1"

class
	EL_SQUARE_POINT_ARRAY

inherit
	EL_RECTANGLE_POINT_ARRAY
		rename
			make as make_sized
		end

create
	make

feature {NONE} -- Initialization

	make (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			make_default
			p0.copy (a_p0)
			set_point_on_circle (p1, a_p0, angle, width)
			set_point_on_circle (p2, p1, angle + radians (90), width)
			set_point_on_circle (p3, p2, angle + radians (180), width)
		end

end
