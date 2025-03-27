note
	description: "Duplicity backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 9:45:31 GMT (Wednesday 26th March 2025)"
	revision: "6"

class
	DUPLICITY_BACKUP_OS_CMD

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} execute, has_error
		end

	DUPLICITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (arguments: DUPLICITY_ARGUMENTS; target_dir: DIR_PATH)
		do
			make_command (Command_template)
			put_fields (arguments)
			set_working_directory (target_dir.parent)
		end
end