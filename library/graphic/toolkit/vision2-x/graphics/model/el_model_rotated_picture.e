note
	description: "[
		Model of a flippable, rotatable picture. Requires projector of type ${EL_MODEL_BUFFER_PROJECTOR}
		to be rendered. Flipping is achieved via routine `mirror'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-14 11:40:31 GMT (Wednesday 14th February 2024)"
	revision: "33"

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
			border_drawing := False
			drawing_area := Default_drawing_area
		end

	make (a_points: EL_POINT_ARRAY; a_pixel_buffer: like drawing_area)
		do
			make_with_coordinates (a_points)
			drawing_area := a_pixel_buffer
		end

	make_from_other (other: EL_MODEL_ROTATED_PICTURE)
		do
			default_create
			set_from_other (other)
		end

feature -- Access

	mirror_state: NATURAL_8
		-- bit OR'd combination of `X_axis' and `Y_axis'

	outer_radial_square: EV_RECTANGLE
		local
			l_width, l_height: INTEGER
		do
			if attached outer_radial_square_coordinates.area as p then
				l_width := (p [1].x_precise - p [0].x_precise).rounded
				l_height := (p [2].y_precise - p [1].y_precise).rounded

				create Result.make (p [0].x, p [0].y, l_width, l_height)
			end
		end

feature -- Constants

	Max_width: INTEGER = 65535

feature -- Status query

	border_drawing: EL_BOOLEAN_OPTION

	is_mirrored (axis: INTEGER): BOOLEAN
		require
			valid_axis: Orientation.is_valid_axis (axis)
		do
			Result := (mirror_state.to_integer_32 & axis).to_boolean
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := same_points (other)
					and then mirror_state = other.mirror_state
					and then drawing_area = other.drawing_area
		end

feature -- Transformation

	mirror (axis: INTEGER)
		-- invert the mirror state for axis `axis'
		require
			valid_axis: Orientation.is_valid_axis (axis)
		do
			mirror_state := mirror_state.bit_xor (axis.to_natural_8)
			invalidate
		end

feature -- Basic operations

	render (drawing: CAIRO_DRAWING_AREA)
		require
			valid_width: width <= Max_width
		do
			drawing.save
			if attached point_array [0] as p then
				drawing.translate (p.x, p.y)
				drawing.rotate (angle)
				drawing.flip (width, height, mirror_state)
				drawing.draw_area (0, 0, drawing_area.scaled_to_size (width, height, Void))
			end
			drawing.restore
			progress_listener.notify_tick
		end

feature -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				Precursor (other)
				create border_drawing.make (other.border_drawing.is_enabled)
			end
		end

	set_from_other (other: EL_MODEL_ROTATED_PICTURE)
		do
			set_coordinates_from (other)
			drawing_area := other.drawing_area
			set_foreground_color (other.foreground_color)
			if other.is_filled then
				set_background_color (other.background_color)
			end
			border_drawing.set_state (other.border_drawing.is_enabled)
			mirror_state := other.mirror_state
		end

feature {EV_MODEL_DRAWER, EV_MODEL} -- Access

	drawing_area: CAIRO_DRAWING_AREA

feature {NONE} -- Constants

	Default_drawing_area: CAIRO_DRAWING_AREA
		once
			create Result.make_with_size (1, 1)
		end

	Width_mask: NATURAL = 0xFFFF

end