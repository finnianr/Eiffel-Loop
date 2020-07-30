note
	description: "Screen"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-23 9:35:20 GMT (Thursday 23rd July 2020)"
	revision: "9"

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

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		undefine
			is_equal, default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			set_dimensions ((width_mm / 10).truncated_to_real, (height_mm / 10).truncated_to_real)
		end

feature -- Access

	resolution: STRING
		do
			Result := width.out + "x" + height.out
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		do
			Result := implementation.useable_area
		end

	widget_pixel_color (a_widget: EV_WIDGET; a_x, a_y: INTEGER): EV_COLOR
		do
			if attached {EV_WIDGET_IMP} a_widget.implementation as widget_impl then
				Result := implementation.widget_pixel_color (widget_impl, a_x, a_y)
			else
				create Result
			end
--		ensure
--			same_color: pixel_color_relative_to (a_widget, a_x, a_y) ~ Result
			-- (May 2013) Ok on Linux Mint, failed on Windows 7
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
		do
			horizontal_resolution := width / a_width_cms; vertical_resolution := height / a_height_cms
			width_cms := a_width_cms; height_cms := a_height_cms
		end

feature -- Conversion

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

	dimension_pixels (dimension: NATURAL_8; distance_cms: REAL): INTEGER
			-- `distance_cms' in centimeters to pixels in `dimension'
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			if dimension = By_width then
				Result := horizontal_pixels (distance_cms)
			else
				Result := vertical_pixels (distance_cms)
			end
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
