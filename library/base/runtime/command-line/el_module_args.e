note
	description: "Shared access to routines of class [$source EL_COMMAND_LINE_ARGUMENTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:19:59 GMT (Thursday 6th February 2020)"
	revision: "12"

deferred class
	EL_MODULE_ARGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Args: EL_COMMAND_LINE_ARGUMENTS
			--
		once
			create Result.make
		end

end
