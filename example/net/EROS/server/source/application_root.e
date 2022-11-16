note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		FOURIER_MATH_SERVER_APP,
		CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP,

	-- Installation
		EL_STANDARD_INSTALLER_APP,
		UNINSTALL_APP
	]

create
	make

note
	ideas: "[
		Sept 2018
		* Create an online service tool to do SVG rendering of buttons with png for monitor
	]"

end