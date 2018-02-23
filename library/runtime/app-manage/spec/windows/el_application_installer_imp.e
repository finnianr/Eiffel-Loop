note
	description: "Windows implementation of [$source EL_APPLICATION_INSTALLER_I]' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_APPLICATION_INSTALLER_IMP

inherit
	EL_APPLICATION_INSTALLER_I
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
