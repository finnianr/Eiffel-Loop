note
	description: "Shared access to instance of class conforming to [$source EL_EXECUTABLE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 11:13:54 GMT (Sunday 13th September 2020)"
	revision: "1"

deferred class
	EL_MODULE_EXECUTABLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Executable: EL_EXECUTABLE_I
		once
			create {EL_EXECUTABLE_IMP} Result.make
		end
end
