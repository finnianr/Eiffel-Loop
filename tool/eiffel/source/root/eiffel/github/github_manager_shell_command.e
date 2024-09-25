note
	description: "Github manager shell command"
	notes: "[
		Use this command to [https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage setup credentials store]
		
			git config --global credential.helper store
			
		~/.git-credentials
		
			https://<user>:<PAT>@github.com
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 15:21:39 GMT (Wednesday 25th September 2024)"
	revision: "41"

class
	GITHUB_MANAGER_SHELL_COMMAND

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_STRING_8_CONSTANTS; EL_EIFFEL_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path: FILE_PATH)
		do
			make_shell ("GITHUB MENU", 10)
			config_path := a_config_path
			create config.make (a_config_path)
			create manifest.make_from_file (config.source_manifest_path)
			create source_change_table.make (100)
		end

feature -- Constants

	Description: STRING = "Command shell for updating github repository"

feature {NONE} -- Commands

	git_commit
		local
			comment, template: ZSTRING; cmd: EL_OS_COMMAND
		do
			comment := User_input.line ("Enter a commitment comment")
			lio.put_new_line
			if not User_input.escape_pressed then
				template := "[
					git add -u
					git add .
					git commit -m "#"
				]"
				template.substitute_tuple ([comment])
				across template.split ('%N') as list loop
					create cmd.make (list.item)
					cmd.set_working_directory (config.github_dir)
--					cmd.dry_run.enable
					cmd.execute
				end
				lio.put_new_line
			end
		end

	git_push_origin_master
		local
			push_cmd: EL_OS_COMMAND
		do
			across << True, False >> as is_plain_text loop
				File.write_text (Credentials_path, config.new_credentials_text (is_plain_text.item))
				if is_plain_text.item then
					create push_cmd.make ("git push -u origin master")
					push_cmd.set_working_directory (config.github_dir)
					push_cmd.execute
					if push_cmd.has_error then
						push_cmd.print_error ("pushing to master")
					else
						lio.put_labeled_string ("push", "DONE")
						lio.put_new_line
					end
				end
			end
		end

	git_force_push_origin
		-- force-push the new HEAD commit (DANGEROUS so not in menu)
		-- (Used after rolling back the most recent commit locally with: git reset HEAD^ )
		-- https://stackoverflow.com/questions/8225125/remove-last-commit-from-remote-git-repository
		local
			push_cmd: EL_OS_COMMAND
		do
			across << True, False >> as is_plain_text loop
				File.write_text (Credentials_path, config.new_credentials_text (is_plain_text.item))
				if is_plain_text.item then
					create push_cmd.make ("git push origin +HEAD")
					push_cmd.set_working_directory (config.github_dir)
					push_cmd.execute
					if push_cmd.has_error then
						push_cmd.print_error ("force pushing to master")
					else
						lio.put_labeled_string ("push", "DONE")
						lio.put_new_line
					end
				end
			end
		end

	git_log
		local
			day_count: INTEGER; date: EL_DATE; template, date_string, line: ZSTRING
			log_cmd: EL_CAPTURED_OS_COMMAND; index: INTEGER
		do
			template := "git --no-pager log --after='%S' --date=short --pretty=format:'%%ad %%s'"
			day_count := User_input.integer ("Number of days to print comments")
			if day_count > 0 then
				create date.make_now_utc
				date.day_add (day_count.opposite)
				create log_cmd.make (template #$ [date.formatted_out ("yyyy-[0]mm-[0]dd")])
				log_cmd.set_working_directory (config.github_dir)
--				log_cmd.dry_run.enable
				log_cmd.execute
				if log_cmd.has_error then
					lio.put_line ("Command error")
				else
					lio.put_new_line
					across log_cmd.lines as list loop
						line := list.item; index := 1
						date_string := line.substring_to_from (' ', $index)
						lio.put_labeled_string (date_string, line.substring_end (index))
						lio.put_new_line
					end
					lio.put_new_line
				end
			end
		end

	rsync_to_github_dir
		local
			rsync_cmd: EL_OS_COMMAND; valid_arguments: BOOLEAN_REF
		do
			update_notes
			lio.put_new_line

			if source_change_table.sum_count = 0 and deletion_count = 0 then
				lio.put_line ("No project or source changes found")
			else
				across source_change_table as table loop
					lio.put_labeled_substitution ("Changes to", "%"*.%S%" files = %S", [table.key, table.item.item])
					lio.put_new_line
				end
				lio.put_integer_field ("Deleted count", deletion_count)
				lio.put_new_line_x2
				create rsync_cmd.make (config.rsync_template)
				create valid_arguments
				set_rsync_arguments (rsync_cmd, Empty_string_8, valid_arguments)
				if valid_arguments.item then
					rsync_cmd.execute
				end
			end
		end

	update_personal_access_token
		local
			user: EL_USER_CRYPTO_OPERATIONS; new_token, pyxis_fragment: ZSTRING
			credential: EL_AES_CREDENTIAL; encrypted_token: STRING
		do
			new_token := User_input.line ("Cut and paste access token")
			create credential.make
			user.validate (credential, Void)

			encrypted_token := credential.new_aes_encrypter (256).base_64_encrypted (new_token.to_utf_8)

			pyxis_fragment := Access_token_template #$ [encrypted_token, credential.salt_base_64, credential.target_base_64]

			lio.put_labeled_string ("Cut and paste lines", "")
			lio.put_new_line
			across pyxis_fragment.lines as line loop
				lio.put_line (line.item)
			end
			lio.put_new_line
			lio.put_line ("Restart github manager")
			Command.launch_gedit (config_path)
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Update github directory",		agent rsync_to_github_dir],
				["Update personal access token",	agent update_personal_access_token],
				["git add + commit",					agent git_commit],
				["git log --after='X'",				agent git_log],
				["git push -u origin master",		agent git_push_origin_master]
			>>)
		end

feature {NONE} -- Implementation

	edit_notes (source_path: FILE_PATH)
		local
			found: BOOLEAN; source_dir: DIR_PATH
			editor: NOTE_EDITOR
		do
			if source_path.exists and then attached manifest.notes_table as table then
				across table.key_list as key until found loop
					source_dir := key.item
					if source_dir.is_parent_of (source_path) then
						found := True
					end
				end
				if found and then table.has_key (source_dir) then
					create editor.make (table.found_item, Void)
					editor.set_file_path (source_path)
					lio.put_path_field ("Edit notes for %S", source_path)
					lio.put_new_line
					editor.edit
				end
			end
		end

	set_rsync_arguments (rsync_cmd: EL_OS_COMMAND; dry_run_option: STRING; valid_arguments: BOOLEAN_REF)
		local
			var: TUPLE [dry_run, source_dir, destination_dir: STRING]
		do
			create var
			if rsync_cmd.valid_tuple (var) then
				rsync_cmd.fill_variables (var)
				rsync_cmd.put_string (var.dry_run, dry_run_option)
				rsync_cmd.put_path (var.source_dir, config.source_dir)
				rsync_cmd.put_path (var.destination_dir, config.github_dir.parent)
				valid_arguments.set_item (True)
			else
				valid_arguments.set_item (False)
			end
		end

	update_notes
		local
			rsync_cmd: EL_CAPTURED_OS_COMMAND; path: FILE_PATH
			valid_arguments: BOOLEAN_REF; line: ZSTRING; deleted: BOOLEAN
		do
			source_change_table.wipe_out
			deletion_count := 0
			create path
			create rsync_cmd.make (config.rsync_template)
			create valid_arguments
			set_rsync_arguments (rsync_cmd, "--dry-run", valid_arguments)
			if valid_arguments.item then
				rsync_cmd.execute
				across rsync_cmd.lines as list loop
					line := list.item
					if not line.has_substring (Dry_run) then
						deleted := line.starts_with (Deleting)
						if deleted then
							line.remove_head (Deleting.count)
						end
						if deleted then
							deletion_count := deletion_count + 1
						else
							path.set_path (line)
							if line.starts_with (config.source_dir.base)
								and then path.has_extension (E_extension)
							then
								edit_notes (config.source_dir.parent.plus_file (path))
							end
							if path.has_dot_extension then
								source_change_table.put (path.extension)
							end
						end
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	deletion_count: INTEGER

	config: GITHUB_CONFIGURATION

	config_path: FILE_PATH

	manifest: SOURCE_MANIFEST

	source_change_table: EL_COUNTER_TABLE [ZSTRING]

feature {NONE} -- Constants

	Credentials_path: FILE_PATH
		once
			Result := Directory.home + ".git-credentials"
		end

	Deleting: ZSTRING
		once
			Result := "deleting "
		end

	Dry_run: ZSTRING
		once
			Result := "(DRY RUN)"
		end

	Access_token_template: ZSTRING
		once
			Result := "[
				encrypted_access_token:
					"#"
				
				credential:
					salt:
						"#"
					digest:
						"#"
			]"
		end

end