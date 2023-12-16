note
	description: "Zero based coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-16 19:34:18 GMT (Saturday 16th December 2023)"
	revision: "10"

class
	EL_POINT_ARRAY

inherit
	EV_COORDINATE_ARRAY
		rename
			make as make_array,
			make_filled as make_filled_array
		redefine
			make_from_area
		end

	EL_GEOMETRY_MATH
		undefine
			is_equal, copy
		end

create
	make_from_area, make_filled

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make_filled (n: INTEGER)
		local
			i, l_upper: INTEGER
		do
			make_filled_array (create {EV_COORDINATE}, 0, n - 1)
			l_upper := upper
			from i := lower + 1 until i > l_upper loop
				put (create {EV_COORDINATE}, i)
				i := i + 1
			end
		end

	make_from_area (a_area: SPECIAL [EV_COORDINATE])
			-- Make an ARRAY using `a' as `area'.
		do
			area := a_area
			upper := a_area.count - 1
		end

feature -- Access

	to_list: EL_ARRAYED_LIST [EV_COORDINATE]
		do
			create Result.make_from_array (Current)
		end

end