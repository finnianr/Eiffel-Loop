note
	description: "Summary description for {EL_MAKE_DIRECTORY_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-17 16:01:59 GMT (Friday 17th June 2016)"
	revision: "3"

deferred class
	EL_MAKE_DIRECTORY_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as directory_path,
			set_path as set_directory_path
		redefine
			directory_path, var_name_path
		end

feature -- Access

	directory_path: EL_DIR_PATH

feature {NONE} -- Evolicity reflection

	var_name_path: ZSTRING
		do
			Result := "directory_path"
		end

end
