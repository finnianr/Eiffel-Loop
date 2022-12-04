note
	description: "Convert all Eiffel configuration files in directory tree to Pyxis format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 21:16:13 GMT (Sunday 4th December 2022)"
	revision: "6"

class
	ECF_TO_PECF_COMMAND

inherit
	EL_NATIVE_DIRECTORY_TREE_FILE_PROCESSOR
		rename
			make as make_processor,
			do_all as execute
		end

	EL_APPLICATION_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (dir_path: DIR_PATH)
		do
			make_processor (dir_path, "*.ecf", create {XML_TO_PYXIS_CONVERTER}.make_default)
		end

feature -- Constants

	Description: STRING = "Convert Eiffel configuration files to Pyxis format"

end