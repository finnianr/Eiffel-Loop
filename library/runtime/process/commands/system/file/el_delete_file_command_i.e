note
	description: "Delete file command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

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
