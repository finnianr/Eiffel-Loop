note
	description: "2 point array forming a line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-16 19:24:26 GMT (Saturday 16th December 2023)"
	revision: "5"

class
	EL_LINE_POINT_ARRAY

inherit
	EL_POINT_ARRAY
		rename
			make_filled as make_sized
		redefine
			make_from_area
		end

create
	make_from_area, make, make_centered

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature {NONE} -- Initialization

	make_from_area (other: SPECIAL [EV_COORDINATE])
		do
			if other.count = line_count then
				Precursor (other)
			else
				make
				area.copy_data (other, 0, 0, line_count)
				upper := (line_count - 1).max (1)
			end
		ensure then
			correct: line_count.max (2) = count
		end

	make_centered (rectangle: EL_MODEL_ROTATED_RECTANGLE; axis: INTEGER)
		-- make center line on `rectangle' for axis
		require
			valid_center: rectangle.is_center_valid
		local
			angle, radius_precise: DOUBLE; i: INTEGER
			center: EV_COORDINATE
		do
			center := rectangle.center
			inspect axis
				when {EL_DIRECTION}.X_axis then
					angle := rectangle.angle
					radius_precise := rectangle.width_precise / 2

				when {EL_DIRECTION}.Y_axis then
					angle := rectangle.angle - radians (90)
					radius_precise := rectangle.height_precise / 2
			else end
			if attached area as coord then
				from i := 0 until i > 1 loop
					set_point_on_circle (coord [i], center, angle, radius_precise)
					angle := angle + radians (180)
					i := i + 1
				end
			end
		end

	make
		do
			make_sized (line_count)
		end

feature -- Access

	p0: EV_COORDINATE
		do
			Result := area [0]
		end

	p1: EV_COORDINATE
		do
			Result := area [1]
		end

	line_count: INTEGER
		do
			Result := 1
		end
end