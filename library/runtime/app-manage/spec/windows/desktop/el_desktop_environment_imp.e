note
	description: "Windows implementation of [$source EL_DESKTOP_ENVIRONMENT_I]' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

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
			file_path: EL_FILE_PATH
		do
			Result := Precursor
			file_path := Result
			file_path.add_extension ("bat")
			if file_path.exists then
				Result := file_path
			end
		end
end
