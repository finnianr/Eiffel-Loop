note
	description: "[
		Model of a flippable, rotatable picture. Requires projector of type [$source EL_MODEL_BUFFER_PROJECTOR]
		to be rendered. Flipping is achieved via routine `mirror'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-29 15:46:18 GMT (Sunday 29th May 2022)"
	revision: "23"

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

	make (a_points: EL_COORDINATE_ARRAY; a_pixel_buffer: like drawing_area)
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
			points: EL_RECTANGLE_POINT_ARRAY; l_width, l_height: INTEGER_32
		do
			points := outer_radial_square_coordinates
			l_width := (points.p1.x_precise - points.p0.x_precise).rounded
			l_height := (points.p2.y_precise - points.p1.y_precise).rounded
			create Result.make (points.p0.x, points.p0.y, l_width, l_height)
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

	is_mirrored_x: BOOLEAN
		do
			Result := is_mirrored ({EL_DIRECTION}.X_axis)
		end

	is_mirrored_y: BOOLEAN
		do
			Result := is_mirrored ({EL_DIRECTION}.Y_axis)
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
		local
			p0: EV_COORDINATE; scaled_drawing: CAIRO_DRAWING_AREA
		do
			p0 := point_array [0]
			drawing.save
			drawing.translate (p0.x, p0.y)
			drawing.rotate (angle)

			drawing.flip (width, height, mirror_state)
			Scaled_drawing_cache.set_new_item_target (Current) -- Ensure `new_scaled_pixel_buffer' refers to `pixel_buffer'
			scaled_drawing := Scaled_drawing_cache.item ((drawing_area.id.to_natural_32 |<< 16) | width.to_natural_32)
			drawing.draw_area (0, 0, scaled_drawing)
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

feature {NONE} -- Implementation

	new_scaled_drawing_area (id_width_key: NATURAL): like drawing_area
		local
			scaled_width: INTEGER
		do
			scaled_width := (id_width_key & Width_mask).to_integer_32

			if scaled_width = drawing_area.width then
				Result := drawing_area
			else
				create Result.make_scaled_to_width (drawing_area, scaled_width)
			end
		end

feature {EV_MODEL_DRAWER, EV_MODEL} -- Access

	drawing_area: CAIRO_DRAWING_AREA

feature {NONE} -- Constants

	Scaled_drawing_cache: EL_CACHE_TABLE [CAIRO_DRAWING_AREA, NATURAL]
		once
			create Result.make (13, agent new_scaled_drawing_area)
		end

	Default_drawing_area: CAIRO_DRAWING_AREA
		once
			create Result.make_with_size (1, 1)
		end

	Width_mask: NATURAL = 0xFFFF

invariant
	valid_pixel_buffer_id: drawing_area.id.to_integer_32 <= Max_width

end