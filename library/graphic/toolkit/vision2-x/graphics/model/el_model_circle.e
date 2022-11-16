note
	description: "Model circle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_MODEL_CIRCLE

inherit
	EV_MODEL_ELLIPSE

	EL_GEOMETRY_MATH undefine default_create end

create
	make

feature {NONE} -- Initialization

	make (a_center: EV_COORDINATE; radius: DOUBLE)
		local
			big_radius: DOUBLE
			p1, p2: EV_COORDINATE
		do
			big_radius := sqrt (radius * radius + radius * radius)
			p1 := point_on_circle (a_center, radians (135).opposite, big_radius)
			p2 := point_on_circle (a_center, radians (45), big_radius)
			make_with_points (p1, p2)
		end
end