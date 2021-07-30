note
	description: "Github manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-30 14:45:19 GMT (Friday 30th July 2021)"
	revision: "1"

class
	GITHUB_MANAGER_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: EL_FILE_PATH)
		do
			make_shell ("GITHUB MENU", 10)
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
				cmd.set_dry_run (True)
				cmd.execute
			end
		end

	git_push_origin_master
		do
			lio.put_labeled_string ("Access token", config.access_token)
			lio.put_new_line
		end

	rsync_to_github
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

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["rsync to github directory", 		agent rsync_to_github],
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
