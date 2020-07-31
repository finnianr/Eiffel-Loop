note
	description: "Square point array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-12 9:40:32 GMT (Friday 12th June 2020)"
	revision: "2"

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
			set_from_point_angle (a_p0, angle, width)
		end

feature -- Element change

	set_from_point_angle (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			p0.copy (a_p0)
			set_point_on_circle (p1, a_p0, angle, width)
			set_point_on_circle (p2, p1, angle + radians (90), width)
			set_point_on_circle (p3, p2, angle + radians (180), width)
		end

end
