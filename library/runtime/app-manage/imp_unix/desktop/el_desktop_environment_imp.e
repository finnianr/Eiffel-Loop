note
	description: "Unix implementation of ${EL_DESKTOP_ENVIRONMENT_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 15:09:10 GMT (Sunday 8th September 2024)"
	revision: "11"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I

	EL_UNIX_IMPLEMENTATION

feature {NONE} -- Implementation

	new_script_path (a_path: FILE_PATH): FILE_PATH
		do
			Result := a_path.twin
			Result.add_extension ("sh")
		end

	set_compatibility_mode (mode: STRING)
		-- set compatibility mode for Windows for registry entry. Eg. WIN7
		do
			do_nothing -- On Unix
		end

end