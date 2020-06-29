note
	description: "[
		Constants for defining directions/dimensions of drawing operations in class [$source EL_DRAWABLE_PIXEL_BUFFER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-27 10:04:45 GMT (Saturday 27th June 2020)"
	revision: "11"

class
	EL_ORIENTATION_ROUTINES

feature -- Contract Support

	is_valid_axis (axis: INTEGER): BOOLEAN
		do
			Result := X_Y_axes.has (axis)
		end

	is_horizontal_side (side: INTEGER): BOOLEAN
		do
			Result := ((Top | Bottom) & side).to_boolean
		end

	is_valid_dimension (dimension: NATURAL_8): BOOLEAN
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

	axis_letter (axis: INTEGER): CHARACTER
		do
			if axis = X_axis then
				Result := 'X'
			else
				Result := 'Y'
			end
		end

	orthogonal (axis: INTEGER): INTEGER
		do
			if axis = X_axis then
				Result := Y_axis
			else
				Result := X_axis
			end
		end

	to_axis (letter: CHARACTER): INTEGER
		do
			inspect letter.as_upper
				when 'X' then
					Result := X_axis
				when 'Y' then
					Result := Y_axis
			else end
		end

	X_axis: INTEGER = 1

	Y_axis: INTEGER = 2

	X_Y_axes: ARRAY [INTEGER]
		once
			Result := << X_axis, Y_axis >>
		end

feature {NONE} -- Directions

	By_height: NATURAL_8 = 1

	By_width: NATURAL_8 = 2

feature {NONE} -- Four sides/directions

	All_directions: ARRAY [INTEGER]
		once
			Result := << Top_left, Top, Top_right, Right, Bottom_right, Bottom, Bottom_left, Left >>
		end

	All_sides: ARRAY [INTEGER]
		once
			Result := << Left, Bottom, Right, Top >>
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

	Bottom_left: INTEGER = 12

	Bottom_right: INTEGER = 6

	Top_left: INTEGER = 9

	Top_right: INTEGER = 3

end
