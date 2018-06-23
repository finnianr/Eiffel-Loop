note
	description: "Desktop uninstall-application installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-16 13:12:45 GMT (Saturday 16th June 2018)"
	revision: "6"

deferred class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		redefine
			command_path
		end

	EL_SHARED_APPLICATION_LIST

feature {NONE} -- Implementation

	command_path: EL_FILE_PATH
		do
			Result := Application_list.Uninstall_script.output_path
		end

end
