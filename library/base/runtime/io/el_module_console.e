note
	description: "Summary description for {EL_MODULE_CONSOLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 10:48:02 GMT (Thursday 28th December 2017)"
	revision: "3"

class
	EL_MODULE_CONSOLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Console: EL_CONSOLE_MANAGER_I
		once ("PROCESS")
			create {EL_CONSOLE_MANAGER_IMP} Result.make
		end
end
