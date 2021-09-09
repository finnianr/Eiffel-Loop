note
	description: "Dir path operand command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:46:40 GMT (Thursday 9th September 2021)"
	revision: "5"

deferred class
	EL_DIR_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as dir_path,
			set_path as set_dir_path
		redefine
			dir_path
		end

feature -- Access

	dir_path: EL_DIR_PATH
end