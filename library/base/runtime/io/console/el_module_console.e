note
	description: "Module console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

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