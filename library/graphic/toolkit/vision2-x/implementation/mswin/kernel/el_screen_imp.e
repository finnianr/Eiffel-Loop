note
	description: "Windows extension to `EV_SCREEN_IMP'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-08 15:40:21 GMT (Saturday 8th October 2016)"
	revision: "2"

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

create
	make

feature -- Access

	widget_pixel_color (a_widget: EV_WIDGET_IMP; a_x, a_y: INTEGER): EV_COLOR
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
				0, 0, 1, 1, dc, a_widget.screen_x +  a_x, a_widget.screen_y + a_y,
				{WEL_RASTER_OPERATIONS_CONSTANTS}.Srccopy
			)

			c := mem_dc.pixel_color (0, 0)
			Result.set_rgb_with_8_bit (c.red, c.green, c.blue)
		end

	border_padding: INTEGER
		do
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

end
