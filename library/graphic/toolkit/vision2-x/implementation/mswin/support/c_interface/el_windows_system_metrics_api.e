note
	description: "Summary description for {EL_WINDOWS_SYSTEM_METRICS_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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