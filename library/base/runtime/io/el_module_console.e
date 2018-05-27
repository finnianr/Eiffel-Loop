note
	description: "Module console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

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
