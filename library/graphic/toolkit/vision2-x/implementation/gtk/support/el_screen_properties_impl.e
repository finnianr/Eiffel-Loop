note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 12:21:41 GMT (Wednesday 24th June 2015)"
	revision: "4"

class
	EL_SCREEN_PROPERTIES_IMPL

inherit
	EL_SCREEN_PROPERTIES_I

	EL_PLATFORM_IMPL
		redefine
			make
		end

	EL_GTK_INIT_API

create
	make, make_special

feature {NONE} -- Initialization

	make_special
		do
			-- Initialize once function that calls a mini GTK app
			-- Must be called before any Vision 2 code
			call (Internal_useable_area)
		end

	make
			--
		local
			screen_resources: EL_X11_SCREEN_RESOURCES_CURRENT
		do
			create screen_resources.make
			screen_width_cms := (screen_resources.connected_output_info.width_mm / 10).truncated_to_real
			screen_height_cms := (screen_resources.connected_output_info.height_mm / 10).truncated_to_real
		end

feature -- Access

	screen_width: INTEGER
			-- screen width in pixels
		do
			Result := {GTK}.gdk_screen_width
		end

	screen_height: INTEGER
			-- screen height in pixels
		do
			Result := {GTK}.gdk_screen_height
		end

	screen_width_cms: REAL
			-- screen width in centimeters

	screen_height_cms: REAL
			-- screen height in centimeters

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		local
			values: like Internal_useable_area
		do
			values := Internal_useable_area
			create Result.make (values [0], values [1], values [2], values [3])
		end

feature -- Status query

	is_windows_aero_theme_active: BOOLEAN
		do
		end

feature {NONE} -- Implementation

	call (any: ANY)
		do
		end

	Internal_useable_area: SPECIAL [INTEGER]
		once ("PROCESS")
			create Result.make_filled (0, 4)
			c_gtk_get_useable_screen_area (Result.base_address)
		end

end
