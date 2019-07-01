note
	description: "Module args"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:46:59 GMT (Friday 25th January 2019)"
	revision: "9"

deferred class
	EL_MODULE_ARGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Args: EL_COMMAND_LINE_ARGUMENTS
			--
		once
			create Result
		end

end
