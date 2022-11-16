note
	description: "Zero based coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_COORDINATE_ARRAY

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
			from i := 0 until i = area.count loop
				target.item (i).copy (area [i])
				i := i + 1
			end
		end

end