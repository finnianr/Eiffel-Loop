note
	description: "Windows extension to `EV_SCREEN_IMP'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-12 15:15:14 GMT (Monday 12th October 2020)"
	revision: "5"

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

	EL_MODULE_WINDOWS_VERSION

	EL_WINDOWS_SYSTEM_METRICS_API

create
	make

feature {NONE} -- Measurement

	border_padding: INTEGER
		do
		end

	height_mm: INTEGER
		do
			if Windows_version.is_10_or_later then
				Result := get_device_caps (dc.item, Vertical_size)
			else
				Result := Monitor_info.height_mm
			end
		end

	width_mm: INTEGER
		do
			if Windows_version.is_10_or_later then
				Result := get_device_caps (dc.item, Horizontal_size)
			else
				Result := Monitor_info.width_mm
			end
		end

feature {NONE} -- Implementation

	color_at_pixel (a_object: EV_POSITIONED; a_x, a_y: INTEGER): EV_COLOR
			-- From stackoverflow
			-- http://stackoverflow.com/questions/19129421/windows-api-getpixel-always-return-clr-invalid-but-setpixel-is-worked
		local
			c: WEL_COLOR_REF; bitmap: WEL_BITMAP; mem_dc: WEL_MEMORY_DC
		do
			create Result
			create mem_dc.make_by_dc (dc)
			create bitmap.make_compatible (dc, 1, 1)
			mem_dc.select_bitmap (bitmap)

			mem_dc.bit_blt (
				0, 0, 1, 1, dc, a_object.screen_x + a_x, a_object.screen_y + a_y,
				{WEL_RASTER_OPERATIONS_CONSTANTS}.Srccopy
			)
			c := mem_dc.pixel_color (0, 0)
			Result.set_rgb_with_8_bit (c.red, c.green, c.blue)
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		local
			l_rect: WEL_RECT
		do
			create l_rect.make (0, 0, 0, 0)
			if c_get_useable_window_area (l_rect.item) then
				create Result.make (l_rect.x, l_rect.y, l_rect.width, l_rect.height)
			else
				create Result
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

feature {NONE} -- Constants

	Monitor_info: EL_WEL_DISPLAY_MONITOR_INFO
		once
			create Result.make
		end
end