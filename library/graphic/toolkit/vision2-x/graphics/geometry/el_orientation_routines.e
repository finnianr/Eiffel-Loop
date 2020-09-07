note
	description: "Constants for defining directions/dimensions/axes of geometry operations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-07 9:37:51 GMT (Monday 7th September 2020)"
	revision: "18"

frozen class
	EL_ORIENTATION_ROUTINES

inherit
	EL_DIRECTION
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			clockwise_directions := << Top_left, Top, Top_right, Right, Bottom_right, Bottom, Bottom_left, Left >>

			create clockwise_positions.make (9)
			create clockwise_sides.make (4)
			create clockwise_corners.make (4)

			across clockwise_directions as list loop
				clockwise_positions.extend (list.item)
				if is_valid_side (list.item) then
					clockwise_sides.extend (list.item)
				end
				if is_valid_corner (list.item) then
					clockwise_corners.extend (list.item)
				end
			end
			clockwise_positions.extend (Center)
		ensure then
			clock_wise_top: clockwise_directions [1] = Top_left and clockwise_directions [3] = Top_right
			clock_wise_bottom: clockwise_directions [5] = Bottom_right and clockwise_directions [7] = Bottom_left

			all_lists_filled:	across << clockwise_positions, clockwise_sides, clockwise_corners >> as list all
										list.item.full
									end
		end

feature -- Access

	unit_vector (position_enum: INTEGER): EL_INTEGER_COORDINATE
		-- coordinate relative to center (0, 0)
		require
			valid_position: is_valid_position (position_enum)
		do
			create Result.make (0, 0)
			inspect position_enum
				-- Going clockwise
				when Top_left then
					Result.move (-1, -1)

				when Top then
					Result.move (0, -1)

				when Top_right then
					Result.move (1, -1)

				when Right then
					Result.move (1, 0)

				when Bottom_right then
					Result.move (1, 1)

				when Bottom then
					Result.move (0, 1)

				when Bottom_left then
					Result.move (-1, 1)

				when Left then
					Result.move (-1, 0)

			else
			end
		end

	rectangle_corner (corner_enum, width, height: INTEGER): EL_INTEGER_COORDINATE
		-- coordinate relative to center (0, 0)
		require
			valid_position: is_valid_corner (corner_enum)
		do
			inspect corner_enum
				-- Going clockwise
				when Top_left then
					create Result.make (0, 0)

				when Top_right then
					create Result.make (width, 0)

				when Bottom_right then
					create Result.make (width, height)

				when Bottom_left then
					create Result.make (0, height)
			else
				create Result.make (0, 0)
			end
		end

feature -- Contract Support

	is_horizontal_side (side: INTEGER): BOOLEAN
		do
			inspect side
				when Top, Bottom then
					Result := True
			else
			end
		end

	is_valid_axis (axis: INTEGER): BOOLEAN
		do
			inspect axis
				when X_axis, Y_axis then
					Result := True
			else
			end
		end

	is_valid_corner (corner: INTEGER): BOOLEAN
		do
			inspect corner
				when Top_left, Top_right, Bottom_left, Bottom_right  then
					Result := True
			else
			end
		end

	is_valid_dimension (dimension: NATURAL_8): BOOLEAN
		do
			inspect dimension
				when By_width, By_height then
					Result := True
			else end
		end

	is_valid_position (position: INTEGER): BOOLEAN
		do
			Result := clockwise_positions.has (position)
		end

	is_valid_side (side: INTEGER): BOOLEAN
		do
			inspect side
				when Left, Bottom, Right, Top then
					Result := True
			else
			end
		end

	is_vertical_side (side: INTEGER): BOOLEAN
		do
			inspect side
				when Left, Right then
					Result := True
			else
			end
		end

feature -- Axis

	X_Y_axes: ARRAY [INTEGER]
		once
			Result := << X_axis, Y_axis >>
		end

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

feature -- Clockwise lists

	clockwise_corners: ARRAYED_LIST [INTEGER]
		-- 4 corners in clockwise order starting `Top_left'

	clockwise_directions: ARRAY [INTEGER]
		-- 8 directions in clockwise order starting `Top_left'

	clockwise_positions: ARRAYED_LIST [INTEGER]
		-- 9 positions in clockwise order starting `Top_left' and finishing `Center'

	clockwise_sides: ARRAYED_LIST [INTEGER]
		-- 4 sides in clockwise order starting `Top'

end
