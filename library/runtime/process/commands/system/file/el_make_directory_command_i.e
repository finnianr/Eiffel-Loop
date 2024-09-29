note
	description: "[
		Create a directory and it's parents if necessary. If directory already exists, no error is reported.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-27 9:45:41 GMT (Friday 27th September 2024)"
	revision: "9"

deferred class
	EL_MAKE_DIRECTORY_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as directory_path,
			set_dir_path as set_directory_path
		end

end