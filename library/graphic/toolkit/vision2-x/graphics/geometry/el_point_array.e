note
	description: "Zero based coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-12 12:45:51 GMT (Tuesday 12th December 2023)"
	revision: "9"

class
	EL_POINT_ARRAY

inherit
	EV_COORDINATE_ARRAY
		rename
			make as make_array
		redefine
			make_from_area
		end

	EL_GEOMETRY_MATH
		undefine
			is_equal, copy
		end

create
	make_from_area, make

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make (n: INTEGER)
		local
			i: INTEGER
		do
			make_filled (create {EV_COORDINATE}, 0, n - 1)
			from i := lower + 1 until i > upper loop
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

feature -- Basic operations

	copy_to (target: like area)
		require
			same_size: count = target.count
		local
			i: INTEGER
		do
			if attached area as p then
				from i := 0 until i = p.count loop
					target.item (i).copy (p [i])
					i := i + 1
				end
			end
		end

end