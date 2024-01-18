note
	description: "Unix implemenation of interface ${EL_SCREEN_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_SCREEN_IMP

inherit
	EL_SCREEN_I
		undefine
			widget_at_mouse_pointer, virtual_width, virtual_height, virtual_x, virtual_y,
			monitor_count, monitor_area_from_position, refresh_graphics_context,
			working_area_from_window, working_area_from_position, monitor_area_from_window
		redefine
			interface
		end

	EV_SCREEN_IMP
		redefine
			interface
		end

	EL_SHARED_USEABLE_SCREEN

create
	make

feature -- Access

	color_at_pixel (a_object: EV_POSITIONED; a_x, a_y: INTEGER): EV_COLOR
		-- From https://rosettacode.org/wiki/Color_of_a_screen_pixel#C
		local
			c: EL_X11_COLOR
		do
			c := Display.pixel_color (a_object.screen_x + a_x, a_object.screen_y + a_y)
			create Result.make_with_rgb (c.red_proportion, c.green_proportion, c.blue_proportion)
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		do
			Result := Useable_screen.area
		end

feature -- Measurement

	height_mm: INTEGER
		do
			Result := display_info.height_mm
		end

	width_mm: INTEGER
		do
			Result := display_info.width_mm
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

feature {NONE} -- Constants

	Display_info: EL_X11_DISPLAY_OUTPUT_INFO
		once
			if attached Display.default_screen_resources.active_output_info as info then
				Result := info
			else
				create Result
			end
		end

	Display: EL_X11_DISPLAY
		once
			create Result.make
		end

end