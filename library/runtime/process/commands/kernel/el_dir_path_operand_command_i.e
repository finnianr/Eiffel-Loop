note
	description: "Directory path operand command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 16:43:03 GMT (Wednesday 26th March 2025)"
	revision: "8"

deferred class
	EL_DIR_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as dir_path,
			set_path as set_dir_path
		redefine
			dir_path
		end

feature -- Access

	dir_path: DIR_PATH
end