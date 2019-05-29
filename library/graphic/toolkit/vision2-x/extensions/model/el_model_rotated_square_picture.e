note
	description: "[
		A pseudo rotable picture. Actual rotation is achieved by using the Cairo graphics API
		to make a new rotated image. See class [$source] EL_DRAWABLE_PIXEL_BUFFER.
		This rotation technique only works if the image is square and the surrounding area matches the fill color.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 16:18:30 GMT (Wednesday 29th May 2019)"
	revision: "2"

class
	EL_MODEL_ROTATED_SQUARE_PICTURE

inherit
	EL_MODEL_ROTATED_RECTANGLE
		rename
			make as make_from_rectangle
		redefine
			project, recursive_transform
		end

	EL_MODEL_MATH
		undefine
			default_create
		end

	EL_ORIENTATION_CONSTANTS
		rename
			Top_left as Top_left_corner
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (image_area: EL_MODEL_ROTATED_RECTANGLE; side: INTEGER; a_image_buffer: like image_buffer; fill_color: EV_COLOR)
		require
			is_square: a_image_buffer.width = a_image_buffer.height
		do
			make_from_other (image_area.circumscribed_square (side))
			image_buffer := a_image_buffer
			set_background_color (fill_color)
		end

feature -- Visitor

	project (a_projector: EV_MODEL_DRAWING_ROUTINES)
		do
			a_projector.draw_figure_picture (new_picture (point_on_circle (center, radians (180 + 45), radius)))
		end

feature -- Element change

	recursive_transform (a_transformation: EV_MODEL_TRANSFORMATION)
		do
			Precursor (a_transformation)
			set_center
		end

feature {NONE} -- Implementation

	image_buffer: EL_DRAWABLE_PIXEL_BUFFER
		-- a rotable image buffer

feature {NONE} -- Factory

	new_picture (a_center: EV_COORDINATE): EV_MODEL_PICTURE
		do
			create Result.make_with_pixmap (new_pixmap (angle, width))
			Result.set_point_position (a_center.x, a_center.y)
		end

	new_pixels_buffer (a_width: INTEGER): EL_DRAWABLE_PIXEL_BUFFER
		do
			create Result.make_with_size (a_width, a_width)
			Result.set_color (background_color)
			Result.fill
		end

	new_pixmap (alpha: DOUBLE; a_width: INTEGER): EV_PIXMAP
		-- pixmap rotated and scaled
		local
			pixels: EL_DRAWABLE_PIXEL_BUFFER; half_width: DOUBLE
		do
			pixels := new_pixels_buffer (a_width)

			half_width := width_precise / 2
			pixels.translate (half_width, half_width)
			pixels.rotate (alpha)
			pixels.translate (half_width.opposite, half_width.opposite)
			pixels.draw_scaled_pixel_buffer (0, 0, a_width, By_width, image_buffer)

			Result := pixels.to_pixmap
		end

end
