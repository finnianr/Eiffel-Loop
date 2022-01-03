note
	description: "Dir path operand command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:52 GMT (Monday 3rd January 2022)"
	revision: "6"

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