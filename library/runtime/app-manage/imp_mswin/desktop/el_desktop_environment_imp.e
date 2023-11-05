note
	description: "Windows implementation of [$source EL_DESKTOP_ENVIRONMENT_I]' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:24:14 GMT (Sunday 5th November 2023)"
	revision: "8"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			application_command
		end

	EL_WINDOWS_IMPLEMENTATION

feature -- Access

	application_command: ZSTRING
		local
			file_path: FILE_PATH
		do
			Result := Precursor
			file_path := Result
			file_path.add_extension ("bat")
			if file_path.exists then
				Result := file_path
			end
		end
end