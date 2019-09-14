note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-14 10:19:27 GMT (Saturday   14th   September   2019)"
	revision: "9"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		FOURIER_MATH_SERVER_APP,
		CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP,

		-- Installation
		EL_STANDARD_INSTALLER_APP,
		UNINSTALL_APP
	]
		once
			create Result
		end

note
	ideas: "[
		Sept 2018
		* Create an online service tool to do SVG rendering of buttons with png for monitor
	]"

end
