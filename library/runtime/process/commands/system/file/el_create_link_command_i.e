note
	description: "Command to create a symbolic link to a file or directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 14:28:44 GMT (Saturday 10th July 2021)"
	revision: "2"

deferred class
	EL_CREATE_LINK_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		rename
			source_path as target_path,
			set_source_path as set_target_path,
			destination_path as link_path,
			set_destination_path as set_link_path
		end

end