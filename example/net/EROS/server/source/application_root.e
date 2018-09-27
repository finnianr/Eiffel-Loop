note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-26 9:58:59 GMT (Wednesday 26th September 2018)"
	revision: "8"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{FOURIER_MATH_SERVER_APP}, {CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP},

				-- Installation
				{EL_STANDARD_INSTALLER_APP}, {UNINSTALL_APP}
			>>
		end

note
	ideas: "[
		Sept 2018
		* Create an online service tool to do SVG rendering of buttons with png for monitor
	]"

end
