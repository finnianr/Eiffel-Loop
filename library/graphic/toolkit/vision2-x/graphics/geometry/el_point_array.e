note
	description: "Extended version of ${EV_COORDINATE_ARRAY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-29 19:13:02 GMT (Monday 29th January 2024)"
	revision: "12"

class
	EL_POINT_ARRAY

inherit
	EV_COORDINATE_ARRAY
		rename
			make as make_array,
			make_filled as make_filled_array
		redefine
			at, item, put
		end

	EL_GEOMETRY_MATH
		undefine
			is_equal, copy
		end

create
	make_from_area, make_filled, make_copy

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make_filled (n: INTEGER)
		local
			i, i_upper: INTEGER; l_area: like area
		do
			create l_area.make_filled (create {EV_COORDINATE}, n)
			i_upper := n - 1
			from i := 1 until i > i_upper loop
				l_area [i] := create {EV_COORDINATE}
				i := i + 1
			end
			make_from_area (l_area)
		end

	make_copy (a_area: like area)
		local
			i, i_upper: INTEGER
		do
			make_filled (a_area.count)
			if attached area as l_area then
				i_upper := a_area.count - 1
				from i := 0 until i > i_upper loop
					l_area [i].copy (a_area [i])
					i := i + 1
				end
			end
		ensure
			valid_bounds: lower = 1 and upper = a_area.count
		end

feature -- Access

	to_list: EL_ARRAYED_LIST [EV_COORDINATE]
		do
			create Result.make_from_array (Current)
		end

	item alias "[]", at alias "@" (i: INTEGER): EV_COORDINATE assign put
			-- Entry at index `i', if in index interval
		do
			Result := area.item (i - lower)
		end

feature -- Element change

	put (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		do
			area.put (v, i - lower)
		end

feature -- Basic operations

	copy_to (target: like area)
		require
			same_size: count = target.count
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := l_area.count.min (target.count) - 1
				from i := 0 until i > i_upper loop
					target [i].copy (l_area [i])
					i := i + 1
				end
			end
		end
end