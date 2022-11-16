note
	description: "Triangle point array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_TRIANGLE_POINT_ARRAY

inherit
	EL_COORDINATE_ARRAY
		redefine
			make_from_area
		end

create
	make_from_area, make_default

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make_from_area (a: SPECIAL [EV_COORDINATE])
		do
			if a.count = line_count then
				Precursor (a)
			else
				make_default
				area.copy_data (a, 0, 0, line_count)
				upper := line_count - 1
			end
		end

	make_default
		do
			make (line_count)
		end

feature -- Access

	p2: EV_COORDINATE
		require
			valid_index: valid_index (2)
		do
			Result := item (2)
		end

	line_count: INTEGER
		do
			Result := 3
		end
end