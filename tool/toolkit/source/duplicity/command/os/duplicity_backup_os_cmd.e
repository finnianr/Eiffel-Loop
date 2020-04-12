note
	description: "Duplicity backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 11:28:33 GMT (Sunday 12th April 2020)"
	revision: "2"

class
	DUPLICITY_BACKUP_OS_CMD

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} execute
		end

	DUPLICITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (arguments: DUPLICITY_ARGUMENTS; target_dir: EL_DIR_PATH)
		do
			make_command (Command_template)
			put_object (arguments)
			set_working_directory (target_dir.parent)
		end
end
