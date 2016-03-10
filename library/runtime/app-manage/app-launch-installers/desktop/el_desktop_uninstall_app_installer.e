note
	description: "Summary description for {EL_DESKTOP_UNINSTALL_APP_INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

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
		end		--

end
