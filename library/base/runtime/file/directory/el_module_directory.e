note
	description: "Module directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:57:41 GMT (Monday 1st July 2019)"
	revision: "7"

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
