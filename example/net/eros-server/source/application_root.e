note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 11:01:43 GMT (Sunday 27th May 2018)"
	revision: "4"

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
				{FOURIER_MATH_SERVER_APP},
				{CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP},

				-- Installer
				{EL_STANDARD_INSTALLER_APP},
				{EL_UNINSTALL_APP}
			>>
		end

end
