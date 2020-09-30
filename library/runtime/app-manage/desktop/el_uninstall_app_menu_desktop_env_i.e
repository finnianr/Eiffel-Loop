note
	description: "Desktop uninstall-application installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-30 8:20:02 GMT (Wednesday 30th September 2020)"
	revision: "8"

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
			if attached Application_list.Uninstall_script as script then
				Result := script.output_path
			else
				create Result
			end
		end

end