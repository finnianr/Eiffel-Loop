note
	description: "Coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-23 16:53:14 GMT (Thursday 23rd May 2019)"
	revision: "1"

class
	EL_COORDINATE_ARRAY

inherit
	EV_COORDINATE_ARRAY
		rename
			make as make_array
		end

create
	make_from_area, make

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_filled (create {EV_COORDINATE}, 1, n)
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
