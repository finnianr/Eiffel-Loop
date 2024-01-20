note
	description: "Shared access to routines of class conforming to ${EL_FILE_ROUTINES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "11"

deferred class
	EL_MODULE_FILE

inherit
	EL_MODULE

feature {NONE} -- Constants

	File: EL_FILE_ROUTINES_I
		once
			create {EL_FILE_ROUTINES_IMP} Result.make
		end

end