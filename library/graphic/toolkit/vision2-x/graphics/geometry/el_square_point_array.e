note
	description: "4 point array forming a square"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-14 10:36:35 GMT (Thursday 14th December 2023)"
	revision: "5"

class
	EL_SQUARE_POINT_ARRAY

inherit
	EL_RECTANGLE_POINT_ARRAY

create
	make, make_at_angle

feature {NONE} -- Initialization

	make_at_angle (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			make
			set_from_point_angle (a_p0, angle, width)
		end

feature -- Element change

	set_from_point_angle (a_p0: EV_COORDINATE; angle, width: DOUBLE)
		-- move `p0' to `a_p0' and set line `p0' to `p1' to `angle'
		local
			i: INTEGER; alpha: DOUBLE
		do
			if attached area as p then
				p [0].copy (a_p0)
				from i := 1; alpha := angle  until i > 3 loop
					set_point_on_circle (p [i], p [i - 1], alpha, width)
					alpha := alpha + radians (90)
					i := i + 1
				end
			end
		end

end