note
	description: "Model math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-23 15:14:41 GMT (Thursday 23rd May 2019)"
	revision: "1"

class
	EL_MODEL_MATH

inherit
	DOUBLE_MATH

feature {NONE} -- Implementation

	point_on_circle (center: EV_COORDINATE; angle, radius: DOUBLE): EV_COORDINATE
		do
			create Result.make_precise (center.x_precise + cosine (angle) * radius, center.y_precise + sine (angle) * radius)
		end
end
