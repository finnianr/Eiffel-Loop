note
	description: "3 point array forming a triangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-31 10:58:43 GMT (Wednesday 31st January 2024)"
	revision: "6"

class
	EL_TRIANGLE_POINT_ARRAY

inherit
	EL_LINE_POINT_ARRAY
		redefine
			point_count
		end

create
	make_from_area, make

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature -- Access

	point_count: INTEGER
		do
			Result := 3
		end
end