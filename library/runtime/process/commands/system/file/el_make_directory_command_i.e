note
	description: "Make directory command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

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

	var_name_path: ZSTRING
		do
			Result := "directory_path"
		end

end
