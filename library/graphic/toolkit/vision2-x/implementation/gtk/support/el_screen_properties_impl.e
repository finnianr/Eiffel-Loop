note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:25:33 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_SCREEN_PROPERTIES_IMPL

inherit
	EL_GRAPHICS_SYSTEM_I

	EL_PLATFORM_IMPL

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			screen_resources: EL_X11_SCREEN_RESOURCES_CURRENT
		do
			create screen_resources.make
			screen_width_cms := (screen_resources.connected_output_info.width_mm / 10).truncated_to_real
			screen_height_cms := (screen_resources.connected_output_info.height_mm / 10).truncated_to_real

			screen_width := {GTK}.gdk_screen_width
			screen_height := {GTK}.gdk_screen_height

			horizontal_resolution := screen_width / screen_width_cms
			vertical_resolution := screen_height / screen_height_cms
		end

feature -- Access

	horizontal_resolution: REAL
			-- Pixels per centimeter

	vertical_resolution: REAL
			-- Pixels per centimeter

	screen_width: INTEGER
			-- screen width in pixels

	screen_height: INTEGER
			-- screen height in pixels

	screen_width_cms: REAL
			-- screen width in centimeters

	screen_height_cms: REAL
			-- screen height in centimeters

feature -- Status query

	is_windows_aero_theme_active: BOOLEAN
		do
		end

end
