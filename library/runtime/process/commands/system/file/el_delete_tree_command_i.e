note
	description: "Delete directory tree command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 13:32:42 GMT (Monday 22nd April 2024)"
	revision: "8"

deferred class
	EL_DELETE_TREE_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as target_path,
			set_dir_path as set_target_path
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			recursive.enable
		end

feature -- Status query

	recursive: EL_BOOLEAN_OPTION
		-- enabled by default
end