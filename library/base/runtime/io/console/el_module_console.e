note
	description: "Shared access to routines of class [$source EL_CONSOLE_MANAGER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-25 18:53:17 GMT (Tuesday 25th February 2020)"
	revision: "9"

deferred class
	EL_MODULE_CONSOLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Console: EL_CONSOLE_MANAGER_I
		once ("PROCESS")
			create {EL_CONSOLE_MANAGER_IMP} Result.make
		end
end
