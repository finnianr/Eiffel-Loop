note
	description: "[
		Create a backup using the [http://duplicity.nongnu.org/ duplicity] utility and configured from a
		file in Pyxis format. See class [$source DUPLICITY_CONFIG] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "23"

class
	DUPLICITY_BACKUP

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_APPLICATION_COMMAND
		redefine
			description
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			type := Backup_type.incremental
			verbosity_level := Verbosity.info
			Precursor
		end

feature -- Access

	Description: STRING = "Create an incremental backup with duplicity command"

	type: ZSTRING

	verbosity_level: STRING

feature -- Basic operations

	 execute
		local
			destination_uri: EL_DIR_URI_PATH; backup_command: DUPLICITY_BACKUP_OS_CMD
			arguments: DUPLICITY_ARGUMENTS; cmd: EL_OS_COMMAND
		do
			lio.put_labeled_string ("Backup", target_dir_base)
			lio.put_new_line
			if backup_dir.exists and then mirror_list.for_all (agent {EL_MIRROR_BACKUP}.is_mounted) then
				create destination_uri.make_from_dir_path (backup_dir #+ target_dir_base)
				lio.put_path_field ("Backup", target_dir)
				lio.put_new_line
				get_backup_type
				if user_accepts_dry_run (destination_uri) then
					lio.put_new_line
					if change_text.is_enabled then
						write_change_comment
					end
					mirror_list.do_all (agent {EL_MIRROR_BACKUP}.set_passphrase)

					if pre_backup_command.count > 0 then
						create cmd.make (pre_backup_command)
						if cmd.has_variable (Var_target_dir) then
							-- This will work on Unix but not on Windows because of possible quoted path
							cmd.put_path (Var_target_dir, target_dir)
						end
						cmd.execute
					end

					lio.put_path_field ("Creating %S", destination_uri)
					lio.put_new_line
					verbosity_level := Verbosity.notice
					create arguments.make (Current, destination_uri, False)
					create backup_command.make (arguments, target_dir)
					backup_command.execute
					if backup_command.has_error then
						lio.put_line ("BACKUP FAILED")
					else
						mirror_backup
					end
				end
			else
				if not backup_dir.exists then
					lio.put_labeled_string ("Backup directory does not exist", backup_dir)
					lio.put_new_line
				end
				across mirror_list as mirror loop
					if mirror.item.is_file and then not mirror.item.is_mounted then
						lio.put_labeled_string ("Not mounted", mirror.item.backup_dir)
						lio.put_new_line
					end
				end
			end
		end

	mirror_backup
		do
			across mirror_list as mirror loop
				mirror.item.transfer (backup_dir #+ target_dir_base)
				lio.put_new_line
			end
			across mirror_list as mirror loop
				if mirror.item.has_error then
					lio.put_labeled_string ("MIRROR ERROR", mirror.item.to_string)
					lio.put_new_line
					across mirror.item.errors as error loop
						lio.put_line (error.item)
					end
					User_input.press_enter
				end
				lio.put_new_line
			end
			lio.put_labeled_string ("Mirroring", "DONE!")
			lio.put_new_line_x2
		end

	get_backup_type
		do
			type := User_input.line ("Enter backup type (default is incremental)")
			if type /~ Backup_type.full then
				type := Backup_type.incremental
			end
			lio.put_new_line
		end

	user_accepts_dry_run (destination_uri: EL_DIR_URI_PATH): BOOLEAN
		local
			target_info: DUPLICITY_TARGET_INFO_OS_CMD; arguments: DUPLICITY_ARGUMENTS
		do
			create arguments.make (Current, destination_uri, True)
			create target_info.make (arguments, target_dir)
			target_info.display_size

			Result := User_input.approved_action_y_n ("Do you wish to continue backup?")
		end

feature {NONE} -- Implementation

	is_file_protocol (dir: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := dir.scheme ~ Protocol.file
		end

	write_change_comment
		local
			comment, date_line: ZSTRING; file: EL_PLAIN_TEXT_FILE
			stamp: DATE_TIME
		do
			comment := User_input.line ("Enter comment for changes.txt")
			if not comment.is_empty then
				create stamp.make_now_utc
				date_line := Date.formatted (stamp.date, {EL_DATE_FORMATS}.short_canonical)
									+ ", " + stamp.time.formatted_out ("hh:[0]mi:[0]ss")
				lio.put_new_line
				create file.make_open_append (target_dir + "changes.txt")
				file.put_lines (<< date_line, comment, Empty_string, Empty_string >>)
				file.close
			end
		end

feature {NONE} -- Constants

	Backup_type: TUPLE [full, incremental: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "full, incremental")
		end

	File_protocol: ZSTRING
		once
			Result := Colon_slash_x2
		end

	Verbosity: TUPLE [error, warning, notice, info, debug_: STRING]
		once
			create Result
			Tuple.fill (Result, "error, warning, notice, info, debug")
		end

end