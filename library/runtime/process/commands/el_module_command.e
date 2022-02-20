note
	description: "Shared access to routines of class [$source EL_COMMAND_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 8:39:24 GMT (Sunday 20th February 2022)"
	revision: "8"

deferred class
	EL_MODULE_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Command: EL_COMMAND_FACTORY
		once
			create Result
		end
end