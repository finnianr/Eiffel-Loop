note
	description: "Unix implementation of `EL_SCREEN_PROPERTIES_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:47:21 GMT (Friday 24th June 2016)"
	revision: "5"

class
	EL_SCREEN_PROPERTIES_IMP

inherit
	EL_SCREEN_PROPERTIES_I

	EL_GTK_INIT_API

	EL_OS_IMPLEMENTATION

create
	make, make_special

feature {NONE} -- Initialization

	make_special
		do
			-- Initialize once function that calls a mini GTK app
			-- Must be called before any Vision 2 code
			call (Internal_useable_area)
		end

	make_default
			--
		local
			screen_resources: EL_X11_SCREEN_RESOURCES_CURRENT
		do
			create screen_resources.make
			width_cms := (screen_resources.connected_output_info.width_mm / 10).truncated_to_real
			height_cms := (screen_resources.connected_output_info.height_mm / 10).truncated_to_real
		end

feature -- Access

	width: INTEGER
			-- screen width in pixels
		do
			Result := {GTK}.gdk_screen_width
		end

	height: INTEGER
			-- screen height in pixels
		do
			Result := {GTK}.gdk_screen_height
		end

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