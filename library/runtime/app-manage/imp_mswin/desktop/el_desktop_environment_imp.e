note
	description: "Windows implementation of [$source EL_DESKTOP_ENVIRONMENT_I]' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			application_command
		end

	EL_OS_IMPLEMENTATION

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