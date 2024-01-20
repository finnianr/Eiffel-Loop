note
	description: "Unix implementation of ${EL_DESKTOP_ENVIRONMENT_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			command_path
		end

	EL_UNIX_IMPLEMENTATION

feature -- Access

	command_path: FILE_PATH
		local
			sh_path: FILE_PATH
		do
			Result := Precursor
			sh_path := Result.twin
			sh_path.add_extension ("sh")
			if sh_path.exists then
				Result := sh_path
			end
		end
end