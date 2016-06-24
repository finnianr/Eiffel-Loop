note
	description: "Summary description for {EL_MAKE_DIRECTORY_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MAKE_DIRECTORY_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_MAKE_DIRECTORY_IMPL]
		rename
			path as directory_path,
			set_path as set_directory_path
		redefine
			directory_path
		end

create
	make, make_default

feature -- Access

	directory_path: EL_DIR_PATH

end
