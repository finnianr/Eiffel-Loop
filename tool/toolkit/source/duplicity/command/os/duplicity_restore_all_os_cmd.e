note
	description: "Duplicity file restore command"
	notes: "[
		Example:

			duplicity --file-to-restore My Ching/source/UI/my_ching_vision2_ui.e \
				file:///home/finnian/Backups/duplicity/Eiffel /home/finnian/Backups-restored/my_ching_vision2_ui.e

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 15:10:42 GMT (Monday 31st July 2023)"
	revision: "8"

class
	DUPLICITY_RESTORE_ALL_OS_CMD

inherit
	EL_OS_COMMAND
		rename
			Var as Standard_var,
			make as make_command
		export
			{NONE} all
			{ANY} execute
		end

	DUPLICITY_OS_COMMAND

	EL_MODULE_TUPLE

	DUPLICITY_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (restore: DUPLICITY_RESTORE; time: DATE_TIME; file_path: FILE_PATH)
		do
			make_command (Cmd_template)
			set_target_dir (restore.backup_dir)
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
			Result := "sudo -E duplicity $encryption --verbosity notice --time $time $target_dir $restored_path"
		end

	Var: TUPLE [time, encryption, restored_path: STRING]
		once
			create Result
			Tuple.fill (Result, "time, encryption, restored_path")
		end

end