note
	description: "Summary description for {DUPLICITY_BACKUP_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUPLICITY_BACKUP_COMMAND

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
