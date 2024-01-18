note
	description: "Unix implementation of ${EL_CAPTURED_OS_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-22 12:17:54 GMT (Saturday 22nd July 2023)"
	revision: "3"

deferred class
	EL_CAPTURED_OS_COMMAND_IMP

inherit
	EL_CAPTURED_OS_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			do_command, is_captured, new_command_parts
		end

end