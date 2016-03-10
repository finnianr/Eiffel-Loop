note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-09 8:37:05 GMT (Thursday 9th July 2015)"
	revision: "4"

class
	EL_SCREEN_PROPERTIES_IMPL

inherit
	EL_PLATFORM_IMPL
		undefine
			make
		end

	EV_SCREEN_IMP
		rename
			vertical_resolution as vertical_pixels_per_inch,
			horizontal_resolution as horizontal_pixels_per_inch,
			width as screen_width,
			height as screen_height,
			log as logarithm,
			interface as ev_interface,
			set_interface as set_ev_interface
		export
			{NONE} all
		redefine
			ev_interface
		end

	EL_SCREEN_PROPERTIES_I

	EL_WINDOWS_SYSTEM_METRICS_API

create
	make, make_special

feature {NONE} -- Initialization

	make_special
		do
			-- Does nothing on Windows but needed in Unix.
		end

feature -- Access

	screen_width_cms: REAL
			-- screen width in centimeters
		do
			Result := Monitor.width_centimeters
		end

	screen_height_cms: REAL
			-- screen height in centimeters
		do
			Result := Monitor.height_centimeters
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


feature {NONE} -- Implementation

	Monitor: EL_WEL_DISPLAY_MONITOR_INFO
			--
		once
			create Result
		end

	ev_interface: detachable EV_SCREEN

end
