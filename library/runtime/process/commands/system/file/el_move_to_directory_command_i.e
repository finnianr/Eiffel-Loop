note
	description: "Move file or directory `source_path' into `destination_path'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 12:29:43 GMT (Sunday 19th April 2020)"
	revision: "1"

deferred class
	EL_MOVE_TO_DIRECTORY_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		redefine
			destination_path
		end

feature -- Access

	destination_path: EL_DIR_PATH

end
