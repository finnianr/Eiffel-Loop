note
	description: "Model drawer with support for rotated pictures using features of [$source EL_DRAWABLE_PIXEL_BUFFER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:00:31 GMT (Sunday 2nd August 2020)"
	revision: "7"

deferred class
	EL_MODEL_DRAWER

inherit
	EV_MODEL_DRAWER
		redefine
			draw_figure_parallelogram
		end

	EL_ORIENTATION_ROUTINES

	EL_MODULE_COLOR

	EL_MODULE_DIRECTORY

feature -- Basic operations

	draw_figure_parallelogram (parallelogram: EV_MODEL_PARALLELOGRAM)
		do
			if attached {EL_MODEL_ROTATED_PICTURE} parallelogram as picture then
				if picture.border_drawing.is_enabled then
					Precursor (parallelogram)
				end
				draw_figure_rotated_picture (picture)
			else
				Precursor (parallelogram)
			end
		end

	draw_figure_rotated_picture (picture: EL_MODEL_ROTATED_PICTURE)
		local
			radial_square, drawable_rectangle, intersection: EV_RECTANGLE; half_width: DOUBLE
			drawing: detachable CAIRO_DRAWING_AREA; x, y: INTEGER
		do
			radial_square := picture.outer_radial_square
			radial_square.move (radial_square.x + offset_x, radial_square.y + offset_y)
			half_width := radial_square.width / 2

			create drawable_rectangle.make (0, 0, drawable.width, drawable.height)
			if drawable_rectangle.contains (radial_square) then
				create drawing.make_with_pixmap (drawable.sub_pixmap (radial_square))

			elseif drawable_rectangle.intersects (radial_square) then
				intersection := drawable_rectangle.intersection (radial_square)
				create drawing.make_with_size (radial_square.width, radial_square.height)
				if attached picture.world.background_color as background_color then
					drawing.set_color (background_color)
					drawing.fill
				end
				if intersection.x > radial_square.x then
					x := intersection.x - radial_square.x
				end
				if intersection.y > radial_square.y then
					y := intersection.y - radial_square.y
				end
				drawing.draw_pixmap (x, y, drawable.sub_pixmap (intersection))
			end
--			Show corners of square	
--			drawing.set_color (Color.cyan)
--			drawing.fill_convex_corners ((picture.width_precise / 5).rounded, Top_left | Top_right | Bottom_right | Bottom_left)

			if attached drawing as l_drawing then
				l_drawing.translate (half_width, half_width)
				l_drawing.rotate (picture.angle)
				l_drawing.translate (picture.width_precise.opposite / 2, picture.height_precise.opposite / 2)

				l_drawing.flip (picture.width, picture.height, picture.mirror_state)

				l_drawing.draw_scaled_drawing_area (By_width, 0, 0, picture.width, picture.drawing_area)
				if attached intersection then
					intersection.move (x, y)
					drawable.draw_sub_pixel_buffer (radial_square.x + x, radial_square.y + y, l_drawing, intersection)
				else
					drawable.draw_pixmap (radial_square.x, radial_square.y, l_drawing.to_pixmap)
				end
			end
		end

end
