note
	description: "Screen"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 20:37:46 GMT (Friday 7th July 2023)"
	revision: "16"

class
	EL_SCREEN

inherit
	EV_SCREEN
		rename
			vertical_resolution as vertical_dpi,
			horizontal_resolution as horizontal_dpi
		export
			{NONE} pixel_color_relative_to -- Doesn't work on Windows
		redefine
			implementation, create_implementation
		end

	EL_MODULE_ORIENTATION

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			set_dimensions ((width_mm / 10).truncated_to_real, (height_mm / 10).truncated_to_real)
		end

feature -- Access

	color_at_pixel (a_object: EV_POSITIONED; a_x, a_y: INTEGER): EV_COLOR
		do
			Result := implementation.color_at_pixel (a_object, a_x, a_y)
		end

	resolution: STRING
		do
			Result := width.out + "x" + height.out
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		do
			Result := implementation.useable_area
		end

feature -- Measurement

	aspect_ratio: REAL
		do
			Result := height_cms / width_cms
		end

	height_cms: REAL
		-- screen height in centimeters

	height_mm: INTEGER
		do
			Result := implementation.height_mm
		end

	horizontal_resolution: REAL
		-- Pixels per centimeter

	vertical_resolution: REAL
		-- Pixels per centimeter

	width_cms: REAL
		-- screen width in centimeters

	width_mm: INTEGER
		do
			Result := implementation.width_mm
		end

feature -- Element change

	set_dimensions (a_width_cms, a_height_cms: REAL)
		-- set display dimensions
		do
			horizontal_resolution := width / a_width_cms; vertical_resolution := height / a_height_cms
			width_cms := a_width_cms; height_cms := a_height_cms
		end

	set_dimensions_by_paper (paper: EL_PAPER_DIMENSIONS; a_width, a_height: INTEGER)
		-- set display dimensions by user supplied `a_width' and `a_height' in pixels of a sheet of
		-- A4 `paper' (or A5 for smaller screens)
		do
			set_dimensions (width / (a_width / paper.width_cms), height / (a_height / paper.height_cms))
		end

feature -- Conversion

	dimension_pixels (dimension: NATURAL_8; distance_cms: REAL): INTEGER
			-- `distance_cms' in centimeters to pixels in `dimension'
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			if dimension = {EL_DIRECTION}.By_width then
				Result := horizontal_pixels (distance_cms)
			else
				Result := vertical_pixels (distance_cms)
			end
		end

	horizontal_pixels (distance_cms: REAL): INTEGER
			--  `distance_cms' in centimeters to horizontal pixels
		do
			Result := (horizontal_resolution * distance_cms).rounded
		end

	vertical_pixels (distance_cms: REAL): INTEGER
			-- `distance_cms' in centimeters to vertical pixels
		do
			Result := (vertical_resolution * distance_cms).rounded
		end

feature -- Positioning

	center (positionable: EV_POSITIONABLE)
		-- center `positionable' inside `useable_area'
		do
			positionable.set_x_position (useable_area.x + (useable_area.width - positionable.width) // 2)
			positionable.set_y_position (useable_area.y + (useable_area.height - positionable.height) // 2)
		end

	center_in (a: EV_POSITIONABLE; b: EV_POSITIONED; top_maximum: BOOLEAN)
		-- center `a' inside `b'
		local
			rect_a, rect_b: EL_RECTANGLE
		do
			create rect_a.make_for_widget (a)
			create rect_b.make_for_widget (b)
			rect_a.move_center (rect_b)
			if top_maximum then
				rect_a.set_y (rect_a.y.max (b.screen_y))
			end
			a.set_position (rect_a.x, rect_a.y)
		end

	set_position (positionable: EV_POSITIONABLE; x, y: INTEGER)
		do
			positionable.set_position (x.max (useable_area.x), (y.max (useable_area.y)))
		end

	set_position_left (positionable: EV_POSITIONABLE; y: INTEGER)
		-- set position of `positionable' at left of `useable_area'
		do
			set_position (positionable, useable_area.width - positionable.width, y)
		end

	set_y_position (positionable: EV_POSITIONABLE; y: INTEGER)
		do
			set_position (positionable, positionable.x_position, y)
		end

	set_x_position (positionable: EV_POSITIONABLE; x: INTEGER)
		do
			set_position (positionable, x, positionable.y_position)
		end

feature -- Status query

	contains (position: EV_COORDINATE; widget: EV_POSITIONABLE): BOOLEAN
		-- `True' if widget can be displayed on screen at `position' without overlapping the edges
		do
			 if 0 <= position.x and then position.x + widget.width <= width then
			 	Result := 0 <= position.y and then position.y + widget.height <= height
			 end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_SCREEN_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_SCREEN_IMP} implementation.make
		end

end