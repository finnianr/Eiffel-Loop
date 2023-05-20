note
	description: "Windows implementation of [$source EL_OS_CAPTURED_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 9:07:31 GMT (Saturday 20th May 2023)"
	revision: "1"

deferred class
	EL_OS_CAPTURED_COMMAND_IMP

inherit
	EL_CAPTURED_OS_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

end