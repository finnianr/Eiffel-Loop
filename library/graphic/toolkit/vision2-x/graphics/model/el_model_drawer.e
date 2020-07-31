note
	description: "Model drawer with support for rotated pictures using features of [$source EL_DRAWABLE_PIXEL_BUFFER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-26 15:36:31 GMT (Sunday 26th July 2020)"
	revision: "5"

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
			pixels: detachable EL_DRAWABLE_PIXEL_BUFFER; x, y: INTEGER
		do
			radial_square := picture.outer_radial_square
			radial_square.move (radial_square.x + offset_x, radial_square.y + offset_y)
			half_width := radial_square.width / 2

			create drawable_rectangle.make (0, 0, drawable.width, drawable.height)
			if drawable_rectangle.contains (radial_square) then
				create pixels.make_with_pixmap (32, drawable.sub_pixmap (radial_square))

			elseif drawable_rectangle.intersects (radial_square) then
				intersection := drawable_rectangle.intersection (radial_square)
				create pixels.make_with_size (32, radial_square.width, radial_square.height)
				if attached picture.world.background_color as background_color then
					pixels.set_color (background_color)
					pixels.fill
				end
				if intersection.x > radial_square.x then
					x := intersection.x - radial_square.x
				end
				if intersection.y > radial_square.y then
					y := intersection.y - radial_square.y
				end
				pixels.draw_pixmap (x, y, drawable.sub_pixmap (intersection))
			end
--			Show corners of square	
--			pixels.set_color (Color.cyan)
--			pixels.fill_convex_corners ((picture.width_precise / 5).rounded, Top_left | Top_right | Bottom_right | Bottom_left)

			if attached pixels as l_pixels then
				l_pixels.translate (half_width, half_width)
				l_pixels.rotate (picture.angle)
				l_pixels.translate (picture.width_precise.opposite / 2, picture.height_precise.opposite / 2)

				l_pixels.flip (picture.width, picture.height, picture.mirror_state)

				l_pixels.draw_scaled_pixel_buffer (By_width, 0, 0, picture.width, picture.pixel_buffer)
				if attached intersection then
					intersection.move (x, y)
					drawable.draw_sub_pixel_buffer (radial_square.x + x, radial_square.y + y, l_pixels.to_rgb_24_buffer, intersection)
				else
					drawable.draw_pixmap (radial_square.x, radial_square.y, l_pixels.to_pixmap)
				end
			end
		end

end
