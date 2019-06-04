note
	description: "Constants for defining directions of drawing operations in class [$source EL_DRAWABLE_PIXEL_BUFFER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 13:36:03 GMT (Tuesday 4th June 2019)"
	revision: "4"

class
	EL_ORIENTATION_ROUTINES

feature -- Contract Support

	is_valid_axis (axis: INTEGER): BOOLEAN
		do
			inspect axis
				when X_axis, Y_axis then
					Result := True
			else end
		end

	is_horizontal_side (side: INTEGER): BOOLEAN
		do
			Result := ((Top | Bottom) & side).to_boolean
		end

	is_valid_dimension (dimension: INTEGER): BOOLEAN
		do
			inspect dimension
				when By_width, By_height then
					Result := True
			else end
		end

	is_valid_corner (corner: INTEGER): BOOLEAN
		do
			Result := All_corners.has (corner)
		end

	is_valid_side (side: INTEGER): BOOLEAN
		do
			Result := All_sides.has (side)
		end

	is_vertical_side (side: INTEGER): BOOLEAN
		do
			Result := ((Left | Right) & side).to_boolean
		end

feature {NONE} -- Axis

	X_axis: INTEGER = 1

	Y_axis: INTEGER = 2

feature {NONE} -- Directions

	By_height: INTEGER = 1

	By_width: INTEGER = 2

feature {NONE} -- Four sides

	All_sides: ARRAY [INTEGER]
		once
			Result := << Left, Top, Bottom, Right >>
		end

	Bottom: INTEGER = 4

	Left: INTEGER = 8

	Right: INTEGER = 2

	Top: INTEGER = 1

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
