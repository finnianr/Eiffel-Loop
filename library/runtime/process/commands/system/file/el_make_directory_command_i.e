note
	description: "Make directory command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 12:02:48 GMT (Wednesday 31st October 2018)"
	revision: "5"

deferred class
	EL_MAKE_DIRECTORY_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as directory_path,
			set_dir_path as set_directory_path
		redefine
			var_name_path
		end

feature {NONE} -- Evolicity reflection

	Var_name_path: STRING = "directory_path"

end
