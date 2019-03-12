note
	description: "Duplicity backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-12 18:46:45 GMT (Tuesday 12th March 2019)"
	revision: "1"

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
