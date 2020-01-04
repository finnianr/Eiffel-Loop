note
	description: "File system commands accepting default UTF-8 encoded arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-04 13:14:34 GMT (Saturday 4th January 2020)"
	revision: "7"

deferred class
	EL_MODULE_FILE_SYSTEM

inherit
	EL_MODULE

feature {NONE} -- Constants

	File_system: EL_FILE_SYSTEM_ROUTINES_I
			-- File system routines using utf-8 encoded file paths
		once
			create {EL_FILE_SYSTEM_ROUTINES_IMP} Result.make
		end

end
