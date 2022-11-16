note
	description: "Delete file command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_DELETE_FILE_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as target_path,
			set_file_path as set_target_path
		end

end