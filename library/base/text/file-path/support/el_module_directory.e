note
	description: "Shared access to routines of class [$source EL_STANDARD_DIRECTORY_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-12 8:23:03 GMT (Saturday 12th February 2022)"
	revision: "10"

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