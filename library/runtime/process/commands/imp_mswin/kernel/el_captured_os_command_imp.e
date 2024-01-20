note
	description: "Windows implementation of ${EL_OS_CAPTURED_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_CAPTURED_OS_COMMAND_IMP

inherit
	EL_CAPTURED_OS_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			do_command, is_captured, new_command_parts
		end

end