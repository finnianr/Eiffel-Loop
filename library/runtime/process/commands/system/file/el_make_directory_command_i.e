note
	description: "Make directory command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_MAKE_DIRECTORY_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as directory_path,
			set_dir_path as set_directory_path
		end

end