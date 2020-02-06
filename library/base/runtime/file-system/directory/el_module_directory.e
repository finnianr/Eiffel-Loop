note
	description: "Shared access to routines of class [$source EL_STANDARD_DIRECTORY_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:04:02 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_DIRECTORY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Directory: EL_STANDARD_DIRECTORY_I
			-- Directory routines using utf-8 encoded file paths
		once
			create {EL_STANDARD_DIRECTORY_IMP} Result
		end

end
