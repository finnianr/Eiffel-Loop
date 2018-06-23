note
	description: "Unix implementation of [$source EL_DESKTOP_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-20 10:47:24 GMT (Wednesday 20th June 2018)"
	revision: "5"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			command_path
		end

	EL_OS_IMPLEMENTATION

feature -- Access

	command_path: EL_FILE_PATH
		local
			sh_path: EL_FILE_PATH
		do
			Result := Precursor
			sh_path := Result.twin
			sh_path.add_extension ("sh")
			if sh_path.exists then
				Result := sh_path
			end
		end
end
