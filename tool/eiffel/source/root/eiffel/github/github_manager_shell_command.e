note
	description: "Github manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 6:58:11 GMT (Monday 7th February 2022)"
	revision: "11"

class
	GITHUB_MANAGER_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL_COMMAND
		rename
			make as make_shell
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_shell ("GITHUB MENU", 10)
			environ_variable.apply
			create config.make (config_path)
		end

feature -- Constants

	Description: STRING = "Command shell for updating github repository"

feature {NONE} -- Implementation

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
			push_cmd: EL_OS_COMMAND; decrypter: EL_AES_ENCRYPTER
			plain_text, cipher_text: STRING
		do
			if Credentials_path.exists then
				decrypter := config.new_credential_decrypter
				cipher_text := File.plain_text (Credentials_path)
				plain_text := decrypter.decrypted_base_64 (cipher_text)
				File.write_text (Credentials_path, plain_text)

				create push_cmd.make ("git push -u origin master")
				push_cmd.set_working_directory (config.github_dir)
				push_cmd.execute
				if push_cmd.has_error then
					lio.put_labeled_lines ("ERROR", push_cmd.errors)
				else
					lio.put_labeled_string ("push", "DONE")
					lio.put_new_line
				end
				-- re-encrypt
				File.write_text (Credentials_path, cipher_text)
			else
				lio.put_path_field ("Cannot find", Credentials_path)
				lio.put_new_line
			end
		end

	rsync_to_github_dir
		local
			rsync_cmd: EL_OS_COMMAND
			var: TUPLE [source_dir, destination_dir: STRING]
		do
			create rsync_cmd.make (config.rsync_template)
			create var
			if rsync_cmd.valid_tuple (var) then
				rsync_cmd.fill_variables (var)
				rsync_cmd.put_path (var.source_dir, config.source_dir)
				rsync_cmd.put_path (var.destination_dir, config.github_dir.parent)
--				rsync_cmd.set_dry_run (True)
				rsync_cmd.execute
			end
		end

	update_source_notes
		local
			editor: NOTE_EDITOR_COMMAND
		do
			create editor.make (config.source_dir + config.source_manifest_path)
			editor.execute
			lio.put_new_line
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["update source notes", 				agent update_source_notes],
				["rsync to github directory", 		agent rsync_to_github_dir],
				["git add + commit",						agent git_commit],
				["git push -u origin master", 		agent git_push_origin_master]
			>>)
		end

feature {NONE} -- Internal attributes

	config: GITHUB_CONFIGURATION

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