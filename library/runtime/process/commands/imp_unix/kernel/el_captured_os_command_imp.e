note
	description: "Unix implementation of ${EL_CAPTURED_OS_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-14 11:22:19 GMT (Tuesday 14th May 2024)"
	revision: "5"

deferred class
	EL_CAPTURED_OS_COMMAND_IMP

inherit
	EL_CAPTURED_OS_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			do_command, is_captured, new_command_parts
		end

end