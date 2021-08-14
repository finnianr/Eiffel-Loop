note
	description: "Github manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-30 17:18:11 GMT (Friday 30th July 2021)"
	revision: "4"

class
	GITHUB_MANAGER_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL_COMMAND

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: EL_FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_shell ("GITHUB MENU", 10)
			environ_variable.apply
			create config.make (config_path)
		end

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
			push_cmd: EL_OS_COMMAND
		do
--			Execution_environment.put (config.access_token, "GITHUB_PAT")
			create push_cmd.make ("git push -u origin master")
			push_cmd.set_working_directory (config.github_dir)
			push_cmd.execute
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
			create editor.make (
				config.source_dir + config.source_manifest_path, config.source_dir + config.license_path
			)
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

	Git_commit_template: ZSTRING
		once
			Result := "[
				git add -u
				git add .
				git commit -m "#"
			]"
		end

end
