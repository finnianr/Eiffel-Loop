note
	description: "Duplicity backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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
			put_object (arguments)
			set_working_directory (target_dir.parent)
		end
end