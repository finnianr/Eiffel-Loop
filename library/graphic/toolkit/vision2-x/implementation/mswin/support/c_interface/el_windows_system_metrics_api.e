note
	description: "Windows system metrics api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

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