note
	description: "Shared access to instance of class conforming to ${EL_EXECUTABLE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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