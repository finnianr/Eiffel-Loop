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
	date: "2020-02-12 16:14:03 GMT (Wednesday 12th February 2020)"
	revision: "2"

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

	DUPLICITY_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (restore: DUPLICITY_RESTORE; date: DATE; file_path: EL_FILE_PATH)
		do
			make_command (Cmd_template)
			put_path (Var.backup_uri, restore.backup_dir)
			put_path (Var.restored_path, restore.restore_dir + file_path.base)
			put_string (Var.date, formatted (date))
			if restore.encryption_key.is_empty then
				put_string (Var.encryption, "--no-encryption")
			else
				put_string (Var.encryption, Empty_string)
			end
		end

feature {NONE} -- Constants

	Var: TUPLE [backup_uri, date, encryption, restored_path: STRING]
		once
			create Result
			Tuple.fill (Result, "backup_uri, date, encryption, restored_path")
		end

	Cmd_template: STRING
		once
			Result := "sudo -E duplicity $encryption --verbosity info --time $date $backup_uri $restored_path"
		end
end
