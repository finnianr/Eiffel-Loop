note
	description: "Unix implementation of ${EL_DESKTOP_ENVIRONMENT_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-24 16:20:32 GMT (Tuesday 24th September 2024)"
	revision: "12"

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

	set_app_compatibility (flags: STRING)
		-- set Windows registry compatibility mode flags Eg. ~WIN7RTM
		do
			do_nothing -- On Unix
		end

end