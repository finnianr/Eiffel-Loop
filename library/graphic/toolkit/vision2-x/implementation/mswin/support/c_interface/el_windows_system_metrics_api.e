note
	description: "Summary description for {EL_WINDOWS_SYSTEM_METRICS_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_WINDOWS_SYSTEM_METRICS_API

feature {NONE} -- C Externals

	c_get_useable_window_area (rectange: POINTER): BOOLEAN
		--
		external
			"C inline use <windows.h>"
		alias
			"SystemParametersInfo (SPI_GETWORKAREA, 0, $rectange, 0)"
		end

end
