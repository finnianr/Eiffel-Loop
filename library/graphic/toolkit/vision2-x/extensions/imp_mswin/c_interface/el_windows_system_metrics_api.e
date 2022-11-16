note
	description: "Windows system metrics api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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