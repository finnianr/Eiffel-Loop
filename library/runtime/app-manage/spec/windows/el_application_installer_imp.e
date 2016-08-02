note
	description: "Windows implementation of `EL_APPLICATION_INSTALLER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:01:13 GMT (Friday 24th June 2016)"
	revision: "1"

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