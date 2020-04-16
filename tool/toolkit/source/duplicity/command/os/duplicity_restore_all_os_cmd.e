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
	date: "2020-04-12 13:00:25 GMT (Sunday 12th April 2020)"
	revision: "3"

class
	DUPLICITY_RESTORE_ALL_OS_CMD

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} execute
		end

	EL_MODULE_TUPLE

	DUPLICITY_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (restore: DUPLICITY_RESTORE; time: DATE_TIME; file_path: EL_FILE_PATH)
		do
			make_command (Cmd_template)
			put_path (Var.backup_uri, restore.backup_dir)
			put_path (Var.restored_path, restore.restore_dir + file_path.base)

			put_string (Var.time, formatted (time))
			if restore.encryption_key.is_empty then
				put_string (Var.encryption, "--no-encryption")
			else
				put_string (Var.encryption, Empty_string)
			end
		end

feature {NONE} -- Constants

	Cmd_template: STRING
		once
			Result := "sudo -E duplicity $encryption --verbosity info --time $time $backup_uri $restored_path"
		end

	Var: TUPLE [backup_uri, time, encryption, restored_path: STRING]
		once
			create Result
			Tuple.fill (Result, "backup_uri, time, encryption, restored_path")
		end

end