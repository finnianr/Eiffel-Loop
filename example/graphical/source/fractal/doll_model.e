note
	description: "Doll model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-23 17:33:59 GMT (Thursday 23rd May 2019)"
	revision: "1"

class
	DOLL_MODEL

inherit
	EV_MODEL_GROUP

	EL_MODEL_MATH
		undefine
			default_create
		end

	EL_MODULE_COLOR
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (rectangle: EL_MODEL_ROTATED_RECTANGLE)
		local
			doll_area: EL_MODEL_ROTATED_RECTANGLE
			head: like new_head; head_area: EL_MODEL_ROTATED_RECTANGLE
		do
			default_create
			create doll_area.make_from_other (rectangle)
			doll_area.scale_x (0.8)
			doll_area.scale_y (0.95)

			extend (new_body (doll_area))

			doll_area.scale_x (0.8)

			head := new_head (doll_area)
			extend (head)

			create head_area.make_with_coordinates (head.point_array)
			head_area.scale (0.75)
			extend (new_face (head_area))

			head_area.scale (0.55)
			head_area.displace (head_area.height_precise * 0.3, Pi / 2)
			extend (new_eyes (head_area))

			head_area.scale (0.45)
			extend (new_lips (head_area))
		end

feature {NONE} -- Factory

	new_body (rectangle: EL_MODEL_ROTATED_RECTANGLE): EV_MODEL_ROTATED_ELLIPSE
		local
			top_left, top_right: EV_COORDINATE
			alpha, top_border: DOUBLE
		do
			create Result
			Result.set_background_color (Color.Red)
			Result.set_foreground_color (Color.Red)
			rectangle.copy_coordinates_to (Result)

			top_left := rectangle.point_array [0] -- top left
			top_right := rectangle.point_array [1] -- top right
			alpha := rectangle.angle + Pi / 2
			top_border := rectangle.height_precise * 0.155
			Result.point_array.item (0).copy (point_on_circle (top_left, alpha, top_border))
			Result.point_array.item (1).copy (point_on_circle (top_right, alpha, top_border))

			Result.center_invalidate
		end

	new_eye_circle: EV_MODEL_ROTATED_ELLIPSE
		do
			create Result
			Result.set_background_color (Color.Black)
			Result.set_foreground_color (Color.Black)
		end

	new_eyes (rectangle: EL_MODEL_ROTATED_RECTANGLE): EV_MODEL_GROUP
		local
			points: EL_COORDINATE_ARRAY; circle: EV_MODEL_ROTATED_ELLIPSE
			alpha, diameter: DOUBLE; i: INTEGER
		do
			diameter := rectangle.width_precise * 0.3
			create Result
			alpha := rectangle.angle
			create points.make (4)
			from i := 1 until i > 2 loop
				circle := new_eye_circle

				if i = 1 then
					-- left
					points [1] := rectangle.point_array [0]
				else
					-- right
					points [1] := point_on_circle (rectangle.point_array [1], alpha + Pi, diameter)
				end
				points [2] := point_on_circle (points [1], alpha, diameter)
				points [3] := point_on_circle (points [2], alpha + Pi / 2, diameter)
				points [4] := point_on_circle (points [3], alpha + Pi, diameter)
				points.copy_to (circle.point_array)
				circle.center_invalidate
				Result.extend (circle)
				i := i + 1
			end
		end

	new_face (rectangle: EL_MODEL_ROTATED_RECTANGLE): EV_MODEL_ROTATED_ELLIPSE
		do
			create Result
			Result.set_background_color (Color.Yellow)
			Result.set_foreground_color (Color.Yellow)
			rectangle.copy_coordinates_to (Result)
			Result.center_invalidate
		end

	new_head (rectangle: EL_MODEL_ROTATED_RECTANGLE): EV_MODEL_ROTATED_ELLIPSE
		local
			top_left, top_right: EV_COORDINATE
			alpha, top_border, diameter: DOUBLE
		do
			create Result
			Result.set_background_color (Color.Red)
			Result.set_foreground_color (Color.Red)

			top_left := rectangle.point_array [0] -- top left
			top_right := rectangle.point_array [1] -- top right

			alpha := rectangle.angle + Pi / 2
			diameter := rectangle.width_precise
			top_border := diameter / 5

			rectangle.copy_coordinates_to (Result)

			Result.point_array [2] := point_on_circle (top_right, alpha, diameter)
			Result.point_array [3] := point_on_circle (top_left, alpha, diameter)
			Result.center_invalidate
		end

	new_lips (rectangle: EL_MODEL_ROTATED_RECTANGLE): EV_MODEL_ROTATED_ELLIPSE
		local
			points: EL_COORDINATE_ARRAY; alpha, height: DOUBLE
		do
			create Result
			Result.set_background_color (Color.Red)
			Result.set_foreground_color (Color.Red)
			alpha := rectangle.angle
			height := rectangle.width_precise * 0.4

			points := rectangle.point_array
			points [1] := point_on_circle (points [4], alpha + Pi / 2 * 3, height)
			points [2] := point_on_circle (points [1], alpha, rectangle.width_precise)

			points.copy_to (Result.point_array)

			Result.center_invalidate
		end

end
