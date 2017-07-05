note
	description: "Summary description for {EL_DIR_PATH_OPERAND_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 11:00:45 GMT (Saturday 1st July 2017)"
	revision: "1"

deferred class
	EL_DIR_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			Default_path as Default_dir_path,
			path as dir_path,
			set_path as set_dir_path
		redefine
			Default_dir_path
		end

feature {NONE} -- Constants

	Default_dir_path: EL_DIR_PATH
		once
			create Result
		end
end
