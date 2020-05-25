note
	description: "[
		Create a backup using the [http://duplicity.nongnu.org/ duplicity] utility and configured from a
		file in Pyxis format. See class [$source DUPLICITY_CONFIG] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 17:23:31 GMT (Monday 25th May 2020)"
	revision: "10"

class
	DUPLICITY_BACKUP

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_COMMAND

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

	type: ZSTRING

	verbosity_level: STRING

feature -- Basic operations

	 execute
		local
			destination_dir: EL_DIR_URI_PATH; continue: BOOLEAN
			backup_command: DUPLICITY_BACKUP_OS_CMD
			arguments: DUPLICITY_ARGUMENTS
		do
			lio.put_labeled_string ("Backup", destination_name)
			lio.put_new_line
			continue := True
			across destination_dir_list.query_if (agent is_file_protocol) as file_uri until not continue loop
				if not file_uri.item.to_dir_path.exists then
					lio.put_labeled_string ("Backup directory does not exist", file_uri.item.to_dir_path)
					lio.put_new_line
					continue := False
				end
			end
			if continue and then destination_dir_list.query_if (agent is_ftp_protocol).count > 0 then
				set_ftp_password
			end
			across destination_dir_list as dir until not continue loop
				destination_dir := dir.item.joined_dir_path (destination_name)
				if dir.cursor_index = 1 then
					lio.put_path_field ("Backup", target_dir)
					lio.put_new_line
					get_backup_type
					continue := user_accepts_dry_run (destination_dir)
					lio.put_new_line
					if continue then
						write_change_comment
					end
				end
				if continue then
					lio.put_path_field ("Creating", destination_dir)
					lio.put_new_line
					verbosity_level := Verbosity.notice
					create arguments.make (Current, destination_dir, False)
					create backup_command.make (arguments, target_dir)
					backup_command.execute
				end
			end
		end

	get_backup_type
		do
			type := User_input.line ("Enter backup type (default is incremental)")
			if type /~ Backup_type.full then
				type := Backup_type.incremental
			end
			lio.put_new_line
		end

	user_accepts_dry_run (destination_dir: EL_DIR_URI_PATH): BOOLEAN
		local
			target_info: DUPLICITY_TARGET_INFO_OS_CMD; arguments: DUPLICITY_ARGUMENTS
		do
			create arguments.make (Current, destination_dir, True)
			create target_info.make (arguments, target_dir)
			target_info.display_size

			lio.put_string ("Do you wish to continue backup (y/n)")
			Result := User_input.entered_letter ('y')
		end

feature {NONE} -- Implementation

	destination_name: ZSTRING
		do
			if name.is_empty then
				Result := target_dir.base
			else
				Result := name
			end
		end

	is_file_protocol (dir: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := dir.scheme ~ Protocol.file
		end

	is_ftp_protocol (dir: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := dir.scheme ~ Protocol.ftp
		end

	set_ftp_password
		local
			ftp_pw, prompt_template, site_name: ZSTRING
		do
			destination_dir_list.find_first_true (agent is_ftp_protocol)
			if not destination_dir_list.exhausted then
				prompt_template := "Enter %S ftp password"
				site_name := destination_dir_list.item.to_string.substring_between_general ("@", "/", 1)
				ftp_pw := User_input.line (prompt_template #$ [site_name])
				lio.put_new_line
				Execution_environment.put (ftp_pw, "FTP_PASSWORD")
			end
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
