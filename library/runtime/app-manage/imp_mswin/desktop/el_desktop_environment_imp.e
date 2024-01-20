note
	description: "Windows implementation of ${EL_DESKTOP_ENVIRONMENT_I}' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

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