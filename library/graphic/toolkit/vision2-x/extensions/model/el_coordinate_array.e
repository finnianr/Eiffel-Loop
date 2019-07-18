note
	description: "Zero based coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-18 9:08:16 GMT (Thursday 18th July 2019)"
	revision: "4"

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
		local
			i: INTEGER
		do
			make_filled (create {EV_COORDINATE}, 0, n - 1)
			from i := 1 until i = n loop
				put (create {EV_COORDINATE}, i)
				i := i + 1
			end
		end

	make_from_area (a: SPECIAL [EV_COORDINATE])
			-- Make an ARRAY using `a' as `area'.
		do
			area := a
			upper := a.count - 1
		end

	make_square (a_p0: EV_COORDINATE; angle, width: DOUBLE)

		do
			make (4)
			p0.copy (a_p0)
			set_point_on_circle (p1, a_p0, angle, width)
			set_point_on_circle (p2, p1, angle + radians (90), width)
			set_point_on_circle (p3, p2, angle + radians (180), width)
		end

feature -- Access

	p0: EV_COORDINATE
		do
			Result := item (0)
		end

	p1: EV_COORDINATE
		require
			valid_index: valid_index (1)
		do
			Result := item (1)
		end

	p2: EV_COORDINATE
		require
			valid_index: valid_index (2)
		do
			Result := item (2)
		end

	p3: EV_COORDINATE
		require
			valid_index: valid_index (3)
		do
			Result := item (3)
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
