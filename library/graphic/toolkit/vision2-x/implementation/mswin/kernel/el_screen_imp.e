note
	description: "Windows extension to EV_SCREEN_IMP"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
			--
		local
			l_result: WEL_COLOR_REF
			l_abs_rect: WEL_RECT
		do
			create Result
			check attached {EV_COLOR_IMP} Result.implementation as color_imp then
				check attached {WEL_WINDOW} a_widget as wel_window then
					l_abs_rect := wel_window.window_rect
					l_result := dc.pixel_color (l_abs_rect.x +  a_x, l_abs_rect.y + a_y)

					color_imp.wel_set_red (l_result.red)
					color_imp.wel_set_green (l_result.green)
					color_imp.wel_set_blue (l_result.blue)
				end
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

end
