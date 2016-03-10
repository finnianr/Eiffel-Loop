note
	description: "Summary description for {EL_DESKTOP_UNINSTALL_APP_INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_DESKTOP_UNINSTALL_APP_INSTALLER

inherit
	EL_DESKTOP_APPLICATION_INSTALLER
		rename
			make as make_installer
		redefine
			create_implementation
		end

create
	make

feature {NONE} -- Initialization

	make (a_application: EL_SUB_APPLICATION; a_launcher: EL_DESKTOP_LAUNCHER)
			--
		do
			make_installer (a_application, << >>, a_launcher)
		end

feature {NONE} -- Implementation

	create_implementation
			--
		do
			create {EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMPL} implementation.make (Current)
		end

end
