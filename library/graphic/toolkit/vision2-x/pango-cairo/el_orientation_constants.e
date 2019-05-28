note
	description: "Constants for defining directions of drawing operations in class [$source EL_DRAWABLE_PIXEL_BUFFER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-28 16:08:36 GMT (Tuesday 28th May 2019)"
	revision: "1"

class
	EL_ORIENTATION_CONSTANTS

feature -- Status query

	is_valid_dimension (dimension: INTEGER): BOOLEAN
		do
			inspect dimension
				when By_width, By_height then
					Result := True
			else

			end
		end

feature {NONE} -- Directions

	By_height: INTEGER = 1

	By_width: INTEGER = 2

feature {NONE} -- Corner bitmasks

	All_corners: ARRAY [INTEGER]
		once
			Result := << Top_left, Top_right, Bottom_right, Bottom_left >>
		end

	Bottom_left: INTEGER = 8

	Bottom_right: INTEGER = 4

	Top_left: INTEGER = 1

	Top_right: INTEGER = 2

end
