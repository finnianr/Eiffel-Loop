note
	description: "Desktop uninstall app installer i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_I

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I
		rename
			make as make_installer
		end

feature {NONE} -- Initialization

	make (a_application: EL_SUB_APPLICATION; a_launcher: EL_DESKTOP_LAUNCHER)
			--
		do
			make_installer (a_application, << >>, a_launcher)
		end

end