note
	description: "Convert all Eiffel configuration files in directory tree to Pyxis format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 17:35:44 GMT (Thursday 6th January 2022)"
	revision: "1"

class
	ECF_TO_PECF_COMMAND

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		rename
			make as make_processor
		end

feature {EL_COMMAND_CLIENT} -- Initialization

	make (dir_path: DIR_PATH)
		do
			make_processor (dir_path, "*.ecf", create {XML_TO_PYXIS_CONVERTER}.make_default)
		end

end