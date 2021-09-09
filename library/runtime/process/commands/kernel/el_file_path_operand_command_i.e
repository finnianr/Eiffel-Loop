note
	description: "File path operand command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:46:15 GMT (Thursday 9th September 2021)"
	revision: "5"

deferred class
	EL_FILE_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as file_path,
			set_path as set_file_path
		redefine
			file_path
		end

feature -- Access

	file_path: EL_FILE_PATH

end