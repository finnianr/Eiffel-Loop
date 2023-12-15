note
	description: "Replicated image model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-14 10:38:58 GMT (Thursday 14th December 2023)"
	revision: "12"

class
	REPLICATED_IMAGE_MODEL

inherit
	EL_MODEL_ROTATED_PICTURE
		export
			{FRACTAL_LAYER} point_array
			{FRACTAL_LAYER_LIST} center
		redefine
			make, project
		end

	MODEL_CONSTANTS

create
	make, make_satellite, make_scaled, default_create

feature {NONE} -- Initialization

	make (a_points: EL_POINT_ARRAY; a_drawing: like drawing_area)
		do
			Precursor (a_points, a_drawing)
			set_foreground_color (Color.White)
--			set_background_color (Color_placeholder)
		end

	make_satellite (other: like Current; size_proportion, displaced_radius_proportion, relative_angle: DOUBLE)
		local
			l_distance: DOUBLE
		do
			make_from_other (other)
			scale (size_proportion)
			l_distance := other.radius * displaced_radius_proportion + radius
			move_in_direction (relative_angle, l_distance)
		end

	make_scaled (other: like Current; position: EV_COORDINATE; proportion: DOUBLE)
		do
			make_from_other (other)
			scale (proportion)
			set_x_y_precise (position)
		end

feature -- Visitor

	project (a_projector: EV_MODEL_DRAWING_ROUTINES)
			-- <Precursor>
		local
			circle: like Once_circle; points: EL_SQUARE_POINT_ARRAY
			l_width: DOUBLE; p0: EV_COORDINATE
		do
			l_width := width_precise.min (height_precise) * 0.17
			p0 := point_on_circle (point_array [0], angle + radians (45), l_width / 6)
			create points.make_at_angle (p0, angle, l_width)

			circle := Once_circle
			points.copy_to (circle.point_array)
			circle.center_invalidate

			a_projector.draw_figure_parallelogram (Current)
			a_projector.draw_figure_rotated_ellipse (circle)
		end

feature {NONE} -- Constants

	Once_circle: EV_MODEL_ROTATED_ELLIPSE
		once
			create Result
			Result.set_foreground_color (foreground_color)
		end
end