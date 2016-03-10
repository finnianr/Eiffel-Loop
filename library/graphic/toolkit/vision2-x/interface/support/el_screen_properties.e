note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-14 10:25:30 GMT (Tuesday 14th July 2015)"
	revision: "5"

class
	EL_SCREEN_PROPERTIES

inherit
	EL_SCREEN_PROPERTIES_I
		rename
			screen_width as width,
			screen_height as height,
			screen_width_cms as width_cms,
			screen_height_cms as height_cms
		end

	EL_CROSS_PLATFORM [EL_SCREEN_PROPERTIES_IMPL]

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make
		local
			display_sizes: LIST [STRING]; l_width_cms, dots_per_cm: REAL
			display_config_path, display_user_config_path: EL_FILE_PATH
		do
			make_default
			height := implementation.screen_height; width := implementation.screen_width

			l_width_cms := implementation.screen_width_cms

			-- On some Windows systems the correct EDID display size is missing
			-- with an erroneous figure of 255 being used instead
			-- For eg. Compaq Presario M5000 laptop with LPL0000 display

			display_user_config_path := Directory.User_configuration + Display_size_relative_path

			if display_user_config_path.exists then
				display_config_path := display_user_config_path
			else
				display_config_path := Directory.Application_installation + Display_size_relative_path
			end

			if display_config_path.exists then
				-- Use config provided by user during installation
				display_sizes := File_system.plain_text (display_config_path).split (':')
				set_physical_dimensions (display_sizes.first.to_real, display_sizes.last.to_real)
				is_display_width_known := True

			elseif l_width_cms >= 10.0 and l_width_cms <= 200.0 then
				-- Display unlikely to be bigger than 2 metres or less than 10 cms
				set_physical_dimensions (l_width_cms, implementation.screen_height_cms)
				is_display_width_known := True

			else
				-- Assume the monitor is 12 inches wide as an average
				dots_per_cm := (Base_dpi * width / Base_resolution / 2.54).rounded
				set_physical_dimensions (width / dots_per_cm, height / dots_per_cm)
			end
		end

feature -- Access

	height: INTEGER
			-- screen height in pixels

	height_cms: REAL
			-- screen height in centimeters

	horizontal_resolution: REAL
			-- Pixels per centimeter

	resolution: STRING
		do
			Result := width.out + "x" + height.out
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		do
			Result := implementation.useable_area
		end

	vertical_resolution: REAL
			-- Pixels per centimeter

	width: INTEGER
			-- screen width in pixels

	width_cms: REAL
			-- screen width in centimeters

feature -- Status query

	is_display_width_known: BOOLEAN
		-- True if default display width is not used

feature -- Element change

	set_physical_dimensions (a_width_cms, a_height_cms: REAL)
		do
			horizontal_resolution := width / a_width_cms; vertical_resolution := height / a_height_cms
			width_cms := a_width_cms; height_cms := a_height_cms
		end

feature -- Conversion

	horizontal_pixels (cms: REAL): INTEGER
			--
		do
			Result := (horizontal_resolution * cms).rounded
		end

	vertical_pixels (cms: REAL): INTEGER
			--
		do
			Result := (vertical_resolution * cms).rounded
		end

feature -- Constants

	Base_dpi: INTEGER
		once
			Result := Base_resolution // 12 -- inches
		end

	Base_resolution: INTEGER = 1024

	Display_size_relative_path: STRING
		once
			Result := "config/display-size-cms.txt"
		end
end
