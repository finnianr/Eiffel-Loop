note
	description: "Rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-19 14:14:11 GMT (Sunday 19th July 2020)"
	revision: "14"

class
	EL_RECTANGLE

inherit
	EV_RECTANGLE

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		undefine
			out
		end

	EL_ORIENTATION_ROUTINES
		rename
			Left as Left_side,
			Top as Top_end,
			Right as Right_side,
			Bottom as Bottom_end
		export
			{NONE} all
			{ANY} is_valid_dimension
		undefine
			out
		end

	EL_MODULE_SCREEN

	EL_DOUBLE_MATH undefine out end

create
	default_create, make, make_cms, make_for_text,
	make_for_pixels, make_for_widget, make_from_cms_tuple, make_from_other,
	make_scaled_for_pixels, make_scaled_for_widget, make_size

convert
	make_from_cms_tuple ({TUPLE [DOUBLE, DOUBLE]}),
	make_from_other ({EV_RECTANGLE}),
	make_for_pixels ({EV_PIXEL_BUFFER}),
	make_for_widget ({EV_PIXMAP})

feature {NONE} -- Initialization

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
			make (0, 0, font.string_width (to_unicode_general (a_text)), font.line_height)
		end

	make_for_pixels (buffer: EV_PIXEL_BUFFER)
		do
			make (0, 0, buffer.width, buffer.height)
		end

	make_for_widget (widget: EV_POSITIONED)
		do
			make (0, 0, widget.width, widget.height)
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

	make_scaled_for_pixels (dimension: NATURAL_8; buffer: EV_PIXEL_BUFFER; size: INTEGER)
		do
			make_for_pixels (buffer)
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

feature -- Measurement

	area: INTEGER
		do
			Result := width * height
		end

feature -- Status query

	is_default: BOOLEAN
		do
			Result := not (x.to_boolean or y.to_boolean or width.to_boolean or height.to_boolean)
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

feature -- Element change

	scale (proportion: DOUBLE)
		do
			set_width ((width * proportion).rounded)
			set_height ((height * proportion).rounded)
		end

	scale_to_height (a_height: INTEGER)
		do
			scale_to_size (By_height, a_height)
		end

	scale_to_size (dimension: NATURAL_8; size: INTEGER)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			if dimension = By_width then
				height := (height * size / width).rounded
				width := size
			else
				width := (width * size / height).rounded
				height := size
			end
		ensure
			proportions_unchanged: approximately_equal (old (height / width), height / width, 0.02)
		end

	scale_to_width (a_width: INTEGER)
		do
			scale_to_size (By_width, a_width)
		end

feature -- Conversion

	to_point_array: EL_COORDINATE_ARRAY
		do
			create Result.make (4)
			Result [0] := upper_left
			Result [1] := upper_right
			Result [2] := lower_right
			Result [3] := lower_left
		end

end
