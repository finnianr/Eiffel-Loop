note
	description: "Model circle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-11 9:46:10 GMT (Monday 11th March 2024)"
	revision: "4"

class
	EL_MODEL_CIRCLE

inherit
	EV_MODEL_ELLIPSE
		rename
			Pi as Radian_180,
			Pi_2 as Radian_90,
			Pi_4 as Radian_45
		end

	EL_GEOMETRY_MATH undefine default_create end

create
	make

feature {NONE} -- Initialization

	make (a_center: EV_COORDINATE; radius: DOUBLE)
		local
			big_radius: DOUBLE; p1, p2: EV_COORDINATE
		do
		-- Radian_45 = 45 deg
			big_radius := sqrt (radius * radius + radius * radius)
			p1 := point_on_circle (a_center, 3 * Radian_45.opposite, big_radius)
			p2 := point_on_circle (a_center, Radian_45, big_radius)
			make_with_points (p1, p2)
		end
end