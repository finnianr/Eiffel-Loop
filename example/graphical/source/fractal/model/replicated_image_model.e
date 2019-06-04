note
	description: "Replicated image model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 18:50:52 GMT (Tuesday 4th June 2019)"
	revision: "3"

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
		undefine
			default_create
		end

	EL_ORIENTATION_ROUTINES
		rename
			Top_left as Top_left_corner
		undefine
			default_create
		end

create
	make, make_satellite, make_default, make_scaled

feature {NONE} -- Initialization

	make (a_points: EL_COORDINATE_ARRAY; a_pixel_buffer: like pixel_buffer)
		do
			Precursor (a_points, a_pixel_buffer)
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
			displace (l_distance, relative_angle)
		end

	make_scaled (other: like Current; position: EV_COORDINATE; proportion: DOUBLE)
		local
			points: like point_array
			l_width, l_height: DOUBLE
		do
			make_from_other (other)
			scale (proportion)
			set_x_y_precise (position)
		end

feature -- Basic operations

	render (pixels: EL_DRAWABLE_PIXEL_BUFFER)
		local
			p0: EV_COORDINATE
		do
			p0 := point_array [0]
			pixels.save
			pixels.translate (p0.x, p0.y)
			pixels.rotate (angle)
			pixels.draw_scaled_pixel_buffer (0, 0, width, By_width, pixel_buffer)
			pixels.restore
		end

feature -- Visitor

	project (a_projector: EV_MODEL_DRAWING_ROUTINES)
			-- <Precursor>
		do
			a_projector.draw_figure_parallelogram (Current)

		end

end
