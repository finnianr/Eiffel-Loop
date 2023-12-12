note
	description: "Rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-12 12:45:51 GMT (Tuesday 12th December 2023)"
	revision: "30"

class
	EL_RECTANGLE

inherit
	EV_RECTANGLE

	EL_MODULE_SCREEN; EL_MODULE_ORIENTATION ; EL_MODULE_TEXT

create
	default_create, make, make_cms, make_for_text,
	make_for_widget, make_from_cms_tuple, make_from_other,
	make_scaled_for_widget, make_size

convert
	make_from_cms_tuple ({TUPLE [DOUBLE, DOUBLE]}), make_from_other ({EV_RECTANGLE}),
	make_for_widget ({EV_POSITIONED})

feature {EV_ANY_HANDLER} -- Initialization

	make_cms (x_cms, y_cms, width_cms, height_cms: REAL)
		-- make from arguments in centimeters
		do
			make (
				Screen.horizontal_pixels (x_cms), Screen.vertical_pixels (y_cms),
				Screen.horizontal_pixels (width_cms), Screen.vertical_pixels (height_cms)
			)
		end

	make_for_text (a_text: READABLE_STRING_GENERAL; font: EV_FONT)
		do
			make (0, 0, Text.string_width (a_text, font), font.line_height)
		end

	make_for_widget (widget: EV_POSITIONED)
		do
			make (widget.screen_x, widget.screen_y, widget.width, widget.height)
		end

	make_from_cms_tuple (a: TUPLE [width, height: DOUBLE])
		do
			make_cms (0, 0, a.width.truncated_to_real, a.height.truncated_to_real)
		end

	make_from_other (other: EV_RECTANGLE)
		do
			make (other.x, other.y, other.width, other.height)
		end

	make_scaled_for_widget (dimension: NATURAL_8; widget: EV_POSITIONED; size: INTEGER)
		do
			make_for_widget (widget)
			scale_to_size (dimension, size)
		end

	make_size (a_width, a_height: INTEGER)
		do
			make (0, 0, a_width, a_height)
		end

feature -- Access

	center_x: INTEGER
		do
			Result := x + width // 2
		end

	center_y: INTEGER
		do
			Result := y + height // 2
		end

	dimensions: TUPLE [width, height: INTEGER]
		do
			Result := [width, height]
		end

	edge_coordinate (position_enum: INTEGER): EL_INTEGER_COORDINATE
		-- relative edge coordinate
		require
			valid_position: Orientation.is_valid_position (position_enum)
		do
			create Result.make (x, y)
			inspect position_enum
				-- Going clockwise

				when {EL_DIRECTION}.Top_left then
					Result.move (0, 0)

				when {EL_DIRECTION}.Top then
					Result.move (width // 2, 0)

				when {EL_DIRECTION}.Top_right then
					Result.move (width, 0)

				when {EL_DIRECTION}.Right then
					Result.move (width, height // 2)

				when {EL_DIRECTION}.Bottom_right then
					Result.move (width, height)

				when {EL_DIRECTION}.Bottom then
					Result.move (width // 2, height)

				when {EL_DIRECTION}.Bottom_left then
					Result.move (0, height)

				when {EL_DIRECTION}.Left then
					Result.move (0, height // 2)

			else -- Center
				Result.move (width // 2, height // 2)
			end
		end

feature -- Measurement

	area: INTEGER
		do
			Result := width * height
		end

	aspect_ratio: DOUBLE
		do
			Result := width / height
		end

	aspect_ratio_formatted: ZSTRING
		do
			create Result.make (5)
			Result.append_rounded_double (aspect_ratio, 2)
		end

feature -- Duplication

	centered_text (rectangle: EL_RECTANGLE; a_text: READABLE_STRING_GENERAL; font: EV_FONT): EL_RECTANGLE
		-- rectangle containing `a_text' centered in `Current'
		do
			create Result.make_for_text (a_text, font)
			Result.move_center (Current)
			Result.set_y (Result.y - font.descent // 2)
		end

feature -- Status query

	is_default: BOOLEAN
		do
			Result := not (x.to_boolean or y.to_boolean or width.to_boolean or height.to_boolean)
		end

feature -- Comparison

	same_aspect (other: EL_RECTANGLE): BOOLEAN
		local
			math: EL_DOUBLE_MATH
		do
			Result := math.approximately_equal (aspect_ratio, other.aspect_ratio, 0.01)
		end

	same_size (other: EL_RECTANGLE): BOOLEAN
		do
			Result := width = other.width and height = other.height
		end

feature -- Basic operations

	move_center (other: EV_RECTANGLE)
		-- center `Current' on `other'
		local
			offset_x, offset_y: INTEGER
		do
			offset_x := ((other.width - width) / 2).rounded
			offset_y := ((other.height - height) / 2).rounded
			move (other.x + offset_x, other.y + offset_y)
		end

	move_down_cms (offset_cms: REAL)
		do
			move (x, y + Screen.vertical_pixels (offset_cms))
		end

	move_left_cms (offset_cms: REAL)
		do
			move (x - Screen.horizontal_pixels (offset_cms), y)
		end

	move_right_cms (offset_cms: REAL)
		do
			move (x + Screen.horizontal_pixels (offset_cms), y)
		end

	move_up_cms (offset_cms: REAL)
		do
			move (x, y - Screen.vertical_pixels (offset_cms))
		end

	move_outside (other: EV_RECTANGLE; direction_enum: INTEGER; border_cms: REAL)
		-- move `Current' to outside of `other' in direction of `direction_enum'
		-- with a border clearance of `border_cms' centimeters
		require
			valid_direction_enum: Orientation.is_valid_position (direction_enum)
		local
			border_x, border_y: INTEGER
			unit: EL_INTEGER_COORDINATE
		do
			border_x := Screen.horizontal_pixels (border_cms)
			border_y := Screen.vertical_pixels (border_cms)
			unit := Orientation.unit_vector (direction_enum)
			move_center (other)
			move_by (((width + other.width) // 2 + border_x) * unit.x, ((height + other.height) // 2 + border_y) * unit.y)
		end

	move_by (delta_x, delta_y: INTEGER)
		do
			x := x + delta_x; y := y + delta_y
		end

	print_info (log: EL_LOGGABLE; name: READABLE_STRING_GENERAL)
		local
			l_name: READABLE_STRING_GENERAL
		do
			l_name := name
			if l_name.is_empty then
				l_name := generator
			end
			log.put_labeled_substitution (
				l_name, "position = (%S, %S); dimensions = %Sx%S; aspect ratio = %S", [x, y, width, height, aspect_ratio_formatted]
			)
			log.put_new_line
		end

feature -- Element change

	scale (proportion: DOUBLE)
		do
			set_width ((width * proportion).rounded)
			set_height ((height * proportion).rounded)
		end

	scale_to_height (a_height: INTEGER)
		do
			scale_to_size ({EL_DIRECTION}.By_height, a_height)
		end

	scale_to_size (dimension: NATURAL_8; size: INTEGER)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			if dimension = {EL_DIRECTION}.By_width then
				height := (height * size / width).rounded
				width := size
			else
				width := (width * size / height).rounded
				height := size
			end
		ensure
			proportions_unchanged: old (height / width).rounded = (height / width).rounded
		end

	scale_to_width (a_width: INTEGER)
		do
			scale_to_size ({EL_DIRECTION}.By_width, a_width)
		end

feature -- Conversion

	to_point_array: EL_POINT_ARRAY
		do
			create Result.make (4)
			Result [0] := upper_left
			Result [1] := upper_right
			Result [2] := lower_right
			Result [3] := lower_left
		end

end