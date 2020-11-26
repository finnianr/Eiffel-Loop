note
	description: "File path operand command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-24 15:24:05 GMT (Tuesday 24th November 2020)"
	revision: "4"

deferred class
	EL_FILE_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as file_path,
			set_path as set_file_path
		redefine
			Default_path
		end

feature {NONE} -- Constants

	Default_path: EL_FILE_PATH
		once
			Result := Default_file_path
		end
end