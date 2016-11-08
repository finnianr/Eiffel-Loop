note
	description: "Windows implementation of EL_SCREEN_PROPERTIES_I interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-09 17:11:57 GMT (Sunday 9th October 2016)"
	revision: "2"

class
	EL_SCREEN_PROPERTIES_IMP

inherit
	EL_SCREEN_PROPERTIES_I

	EL_MODULE_DISPLAY_SCREEN

	EL_WINDOWS_SYSTEM_METRICS_API

	EL_MODULE_WINDOWS

	EL_OS_IMPLEMENTATION

create
	make, make_special

feature {NONE} -- Initialization

	make_special
		do
			-- Does nothing on Windows but needed in Unix.
		end

	make_default
			--
		local
			display: EL_WEL_DISPLAY_SIZE_INFO
		do
			if Windows.major_version >= 10 then
				create {EL_WEL_WIN_10_DISPLAY_SIZE_INFO} display
			else
				create {EL_WEL_DISPLAY_MONITOR_INFO} display
			end
			width_cms := display.width_centimeters; height_cms := display.height_centimeters
		end

feature -- Access

	width: INTEGER
			-- screen width in pixels
		do
			Result := Display_screen.width
		end

	height: INTEGER
			-- screen height in pixels
		do
			Result := Display_screen.height
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

end
