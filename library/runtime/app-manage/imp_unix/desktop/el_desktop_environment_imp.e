note
	description: "Unix implementation of [$source EL_DESKTOP_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "7"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			command_path
		end

	EL_OS_IMPLEMENTATION

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
