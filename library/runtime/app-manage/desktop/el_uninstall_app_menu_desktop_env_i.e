note
	description: "Desktop uninstall-application installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		redefine
			command_path
		end

	EL_SHARED_APPLICATION_LIST

feature {NONE} -- Implementation

	command_path: FILE_PATH
		do
			if attached Application_list.Uninstall_script as script then
				Result := script.output_path
			else
				create Result
			end
		end

end