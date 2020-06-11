note
	description: "[
		Model of a flippable, rotatable picture. Requires projector of type [$source EL_MODEL_BUFFER_PROJECTOR] to be rendered.
		Flipping is achieved via routine `mirror'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-11 13:57:34 GMT (Thursday 11th June 2020)"
	revision: "14"

class
	EL_MODEL_ROTATED_PICTURE

inherit
	EL_MODEL_ROTATED_RECTANGLE
		rename
			make as make_from_rectangle
		redefine
			copy, default_create, set_from_other, is_equal
		end

	EL_SHARED_PROGRESS_LISTENER

create
	make, default_create, make_from_other

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create pixel_buffer
			border_drawing := False
		end

	make (a_points: EL_COORDINATE_ARRAY; a_pixel_buffer: like pixel_buffer)
		do
			make_with_coordinates (a_points)
			pixel_buffer := a_pixel_buffer
		end

	make_from_other (other: EL_MODEL_ROTATED_PICTURE)
		do
			default_create
			set_from_other (other)
		end

feature -- Access

	outer_radial_square: EV_RECTANGLE
		local
			points: EL_RECTANGLE_POINT_ARRAY; l_width, l_height: INTEGER_32
		do
			points := outer_radial_square_coordinates
			l_width := (points.p1.x_precise - points.p0.x_precise).rounded
			l_height := (points.p2.y_precise - points.p1.y_precise).rounded
			create Result.make (points.p0.x, points.p0.y, l_width, l_height)
		end

	mirror_state: NATURAL_8
		-- bit OR'd combination of `X_axis' and `Y_axis'

feature -- Status query

	border_drawing: EL_BOOLEAN_OPTION

	is_mirrored (axis: INTEGER): BOOLEAN
		require
			valid_axis: is_valid_axis (axis)
		do
			Result := (mirror_state.to_integer_32 & axis).to_boolean
		end

	is_mirrored_x: BOOLEAN
		do
			Result := is_mirrored (X_axis)
		end

	is_mirrored_y: BOOLEAN
		do
			Result := is_mirrored (Y_axis)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := point_array ~ other.point_array
					and then mirror_state = other.mirror_state
					and then pixel_buffer = other.pixel_buffer

		end

feature -- Transformation

	mirror (axis: INTEGER)
		-- invert the mirror state for axis `axis'
		require
			valid_axis: is_valid_axis (axis)
		do
			mirror_state := mirror_state.bit_xor (axis.to_natural_8)
			invalidate
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

			pixels.flip (width, height, mirror_state)

			pixels.draw_scaled_pixel_buffer (0, 0, width, By_width, pixel_buffer)
			pixels.restore
			progress_listener.notify_tick
		end

feature -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				standard_copy (other)
				point_array := point_array.resized_area (point_count)
				set_from_other (other)
			end
		end

	set_from_other (other: EL_MODEL_ROTATED_PICTURE)
		do
			set_coordinates_from (other)
			pixel_buffer := other.pixel_buffer
			set_foreground_color (other.foreground_color)
			if other.is_filled then
				set_background_color (other.background_color)
			end
			border_drawing.set_state (other.border_drawing.is_enabled)
			mirror_state := other.mirror_state
		end

feature {EL_MODEL_BUFFER_PROJECTOR, EV_MODEL} -- Access

	pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER

end
