note
	description: "Summary description for {EL_DESKTOP_UNINSTALL_APP_INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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