note
	description: "3 point array forming a triangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-14 10:21:36 GMT (Thursday 14th December 2023)"
	revision: "4"

class
	EL_TRIANGLE_POINT_ARRAY

inherit
	EL_LINE_POINT_ARRAY
		redefine
			line_count
		end

create
	make_from_area, make

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature -- Access

	p2: EV_COORDINATE
		do
			Result := area [2]
		end

	line_count: INTEGER
		do
			Result := 3
		end
end