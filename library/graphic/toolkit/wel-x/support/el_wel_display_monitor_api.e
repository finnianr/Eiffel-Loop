note
	description: "Summary description for {EL_WEL_DISPLAY_MONITOR_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_WEL_DISPLAY_MONITOR_API

feature {NONE} -- C Externals

	c_size_of_monitor_info_struct: INTEGER
		external
			"C [macro <Winuser.h>]"
		alias
			"sizeof (MONITORINFOEX)"
		end

	cwin_set_struct_size (ptr: POINTER; value: INTEGER)
		external
			"C [struct <Winuser.h>] (MONITORINFOEX, DWORD)"
		alias
			"cbSize"
		end

	cwin_get_monitor_info (hMonitor, lpmi: POINTER): BOOLEAN
			-- SDK BOOL GetMonitorInfo( __in  HMONITOR hMonitor, __out  LPMONITORINFO lpmi);
		external
			"C [macro <Winuser.h>] (HMONITOR, LPMONITORINFOEX): BOOL"
		alias
			"GetMonitorInfo"
		end

	cwin_primary_monitor_from_point (point: POINTER): POINTER
			-- HMONITOR MonitorFromPoint(
			--   __in  POINT pt,
			--   __in  DWORD dwFlags
			-- );
		external
			"C inline use <Winuser.h>"
		alias
			"(MonitorFromPoint(*(PPOINT)$point, MONITOR_DEFAULTTOPRIMARY))"
		end

	cwin_get_device_name (ptr: POINTER): POINTER
		external
			"C [struct <Winuser.h>] (MONITORINFOEX): TCHAR"
		alias
			"szDevice"
		end

end
