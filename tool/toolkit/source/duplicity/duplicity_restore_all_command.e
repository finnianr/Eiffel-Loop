note
	description: "Duplicity file restore command"
	notes: "[
		Example:

			duplicity --file-to-restore My Ching/source/UI/my_ching_vision2_ui.e \
				file:///home/finnian/Backups/duplicity/Eiffel /home/finnian/Backups-restored/my_ching_vision2_ui.e

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-15 11:39:36 GMT (Friday 15th March 2019)"
	revision: "1"

class
	DUPLICITY_RESTORE_ALL_COMMAND

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} execute
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (date: STRING; restored_path: EL_FILE_PATH; backup_uri: EL_DIR_URI_PATH)
		do
			make_command (Cmd_template)
			put_path (Var.backup_uri, backup_uri)
			put_path (Var.restored_path, restored_path)
			put_string (Var.date, date)
		end

feature {NONE} -- Constants

	Var: TUPLE [backup_uri, date, restored_path: STRING]
		once
			create Result
			Tuple.fill (Result, "backup_uri, date, restored_path")
		end

	Cmd_template: STRING
		once
			Result := "sudo -E duplicity --verbosity info --time $date $backup_uri $restored_path"
		end
end
