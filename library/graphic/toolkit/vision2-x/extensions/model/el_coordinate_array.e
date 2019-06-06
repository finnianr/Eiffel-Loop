note
	description: "Zero based coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-05 11:15:17 GMT (Wednesday 5th June 2019)"
	revision: "3"

class
	EL_COORDINATE_ARRAY

inherit
	EV_COORDINATE_ARRAY
		rename
			make as make_array
		redefine
			make_from_area
		end

	EL_MODEL_MATH
		undefine
			is_equal, copy
		end

create
	make_from_area, make, make_square

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_filled (create {EV_COORDINATE}, 0, n - 1)
		end

	make_from_area (a: SPECIAL [EV_COORDINATE])
			-- Make an ARRAY using `a' as `area'.
		do
			area := a
			upper := a.count - 1
		end

	make_square (p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			make (4)
			put (p0, 0)
			put (point_on_circle (p0, angle, width), 1)
			put (point_on_circle (item (1), angle + radians (90), width), 2)
			put (point_on_circle (item (2), angle + radians (180), width), 3)
		end

feature -- Basic operations

	copy_to (target: like area)
		require
			same_size: count = target.count
		local
			i: INTEGER
		do
			from i := 0 until i = area.count loop
				target.item (i).copy (area [i])
				i := i + 1
			end
		end

end
