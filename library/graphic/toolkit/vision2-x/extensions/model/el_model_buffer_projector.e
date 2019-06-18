note
	description: "Model buffer projector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-18 8:58:46 GMT (Tuesday 18th June 2019)"
	revision: "4"

class
	EL_MODEL_BUFFER_PROJECTOR

inherit
	EV_MODEL_BUFFER_PROJECTOR
		redefine
			draw_figure_parallelogram
		end

	EL_ORIENTATION_ROUTINES

	EL_MODULE_COLOR

create
	make, make_with_buffer

feature -- Basic operations

	draw_figure_rotated_picture (picture: EL_MODEL_ROTATED_PICTURE)
		local
			radial_square: EV_RECTANGLE; half_width: DOUBLE
			pixels: EL_DRAWABLE_PIXEL_BUFFER; cropped: EL_RECTANGLE
			x, y: INTEGER
		do
			radial_square := picture.outer_radial_square
			radial_square.move (radial_square.x + offset_x, radial_square.y + offset_y)
			half_width := radial_square.width / 2
			-- crop the square if outside bounds
			if radial_square.x < 0 or radial_square.y < 0 then
				create pixels.make_with_size (radial_square.width, radial_square.height)
				create cropped.make_from_other (radial_square)
				if cropped.x < 0 then
					x := cropped.x.opposite
					cropped.grow_left (cropped.x)
				end
				if cropped.y < 0 then
					y := cropped.y.opposite
					cropped.grow_top (cropped.y)
				end
				pixels.draw_pixmap (x, y, drawable.sub_pixmap (cropped))
			else
				create pixels.make_with_pixmap (drawable.sub_pixmap (radial_square))
			end

--			Show corners of square	
--			pixels.set_color (Color.cyan)
--			pixels.fill_convex_corners ((picture.width_precise / 5).rounded, Top_left | Top_right | Bottom_right | Bottom_left)

			pixels.translate (half_width, half_width)
			pixels.rotate (picture.angle)
			pixels.translate (picture.width_precise.opposite / 2, picture.height_precise.opposite / 2)

			pixels.draw_scaled_pixel_buffer (0, 0, picture.width, By_width, picture.pixel_buffer)

			drawable.draw_pixmap (radial_square.x, radial_square.y, pixels.to_pixmap)
		end

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

end
