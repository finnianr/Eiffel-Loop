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
	date: "2023-01-27 15:00:06 GMT (Friday 27th January 2023)"
	revision: "21"

class
	GITHUB_MANAGER_SHELL_COMMAND

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_STRING_8_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_shell ("GITHUB MENU", 10)
			environ_variable.apply
			create config.make (config_path)
			create manifest.make_from_file (config.source_manifest_path)
		end

feature -- Constants

	Description: STRING = "Command shell for updating github repository"

feature {NONE} -- Commands

	git_commit
		local
			commit_message: ZSTRING; command_list: EL_ZSTRING_LIST
			cmd: EL_OS_COMMAND
		do
			commit_message := User_input.line ("Enter a commit message")
			lio.put_new_line
			create command_list.make_with_lines (Git_commit_template #$ [commit_message])
			across command_list as list loop
				create cmd.make (list.item)
				cmd.set_working_directory (config.github_dir)
--				cmd.set_dry_run (True)
				cmd.execute
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

	rsync_to_github_dir
		local
			rsync_cmd: EL_OS_COMMAND; valid_arguments: BOOLEAN_REF
		do
			update_notes

			if change_count > 0 then
				create rsync_cmd.make (config.rsync_template)
				create valid_arguments
				set_rsync_arguments (rsync_cmd, Empty_string_8, valid_arguments)
				if valid_arguments.item then
					rsync_cmd.execute
				end
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Update github directory",	agent rsync_to_github_dir],
				["git add + commit",				agent git_commit],
				["git push -u origin master", agent git_push_origin_master]
			>>)
		end

feature {NONE} -- Implementation

	edit_notes (source_path: FILE_PATH)
		local
			found: BOOLEAN; source_dir: DIR_PATH
			editor: NOTE_EDITOR
		do
			if source_path.exists and then attached manifest.notes_table as table then
				across table.current_keys as key until found loop
					source_dir := key.item
					if source_dir.is_parent_of (source_path) then
						found := True
					end
				end
				if found and then table.has_key (source_dir) then
					create editor.make (table.found_item, Void)
					editor.set_file_path (source_path)
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
			rsync_cmd: EL_CAPTURED_OS_COMMAND; path, source_path: FILE_PATH
			valid_arguments: BOOLEAN_REF
		do
			change_count := 0

			create rsync_cmd.make (config.rsync_template)
			create valid_arguments
			set_rsync_arguments (rsync_cmd, "--dry-run", valid_arguments)
			if valid_arguments.item then
				rsync_cmd.execute
				across rsync_cmd.lines as line loop
					if line.item.starts_with_zstring (config.source_dir.base) then
						path := line.item
						if path.has_extension ("e") then
							source_path := config.source_dir.parent + path
							lio.put_path_field ("Edit notes for %S", path)
							lio.put_new_line
							edit_notes (source_path)
							change_count := change_count +1
						end
					elseif line.item.starts_with ("deleting ") then
						change_count := change_count + 1
					end
				end
			end
			if change_count = 0 then
				lio.put_line ("No changes found")
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	change_count: INTEGER

	config: GITHUB_CONFIGURATION

	manifest: SOURCE_MANIFEST

feature {NONE} -- Constants

	Credentials_path: FILE_PATH
		once
			Result := Directory.home + ".git-credentials"
		end

	Git_commit_template: ZSTRING
		once
			Result := "[
				git add -u
				git add .
				git commit -m "#"
			]"
		end

end