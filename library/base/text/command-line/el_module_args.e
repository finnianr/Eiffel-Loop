note
	description: "Shared access to routines of class ${EL_COMMAND_LINE_ARGUMENTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-14 16:18:37 GMT (Thursday 14th November 2024)"
	revision: "15"

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