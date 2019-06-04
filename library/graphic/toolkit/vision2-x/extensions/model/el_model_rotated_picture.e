note
	description: "[
		Model of a rotated picture. Requires projector of type [$source EL_MODEL_BUFFER_PROJECTOR] to be rendered.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 17:58:02 GMT (Tuesday 4th June 2019)"
	revision: "3"

class
	EL_MODEL_ROTATED_PICTURE

inherit
	EL_MODEL_ROTATED_RECTANGLE
		rename
			make as make_from_rectangle
		redefine
			make_from_other
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_points: EL_COORDINATE_ARRAY; a_pixel_buffer: like pixel_buffer)
		do
			make_with_coordinates (a_points)
			pixel_buffer := a_pixel_buffer
		end

	make_default
		do
			default_create
			create pixel_buffer
		end

	make_from_other (other: EL_MODEL_ROTATED_PICTURE)
		do
			Precursor (other)
			pixel_buffer := other.pixel_buffer
			set_foreground_color (other.foreground_color)
			if other.is_filled then
				set_background_color (other.background_color)
			end
		end

feature -- Access

	outer_radial_square: EV_RECTANGLE
		local
			points: EL_COORDINATE_ARRAY; l_width, l_height: INTEGER_32
		do
			points := outer_radial_square_coordinates
			l_width := (points.item (1).x_precise - points.item (0).x_precise).rounded
			l_height := (points.item (2).y_precise - points.item (1).y_precise).rounded
			create Result.make (points.item (0).x, points.item (0).y, l_width, l_height)
		end

feature -- Transformation

	mirror (axis: INTEGER)
		require
			valid_axis: is_valid_axis (axis)
		do
			create pixel_buffer.make_mirrored (pixel_buffer, axis)
		end

feature {EL_MODEL_BUFFER_PROJECTOR, EV_MODEL} -- Access

	pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER

end
