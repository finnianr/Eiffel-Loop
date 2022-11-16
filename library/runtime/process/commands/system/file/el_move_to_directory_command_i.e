note
	description: "Move file or directory `source_path' into `destination_path'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_MOVE_TO_DIRECTORY_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		redefine
			destination_path
		end

feature -- Access

	destination_path: DIR_PATH

end