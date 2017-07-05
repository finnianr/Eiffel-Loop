note
	description: "Summary description for {EL_DELETE_FILE_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 17:45:16 GMT (Saturday 1st July 2017)"
	revision: "3"

deferred class
	EL_DELETE_FILE_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as target_path,
			set_file_path as set_target_path
		undefine
			Var_name_path
		end

	EL_DELETION_COMMAND

end
