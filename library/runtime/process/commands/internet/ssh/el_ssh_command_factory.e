note
	description: "Factory for commands conforming to ${EL_SECURE_SHELL_COMMAND}."
	notes: "[
		**Future Addition**
		
		Make a routine to check if a remote file needs updating by obtaining a hash
		
			ssh user@remote_server 'md5sum /path/to/remote/file'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 12:28:28 GMT (Tuesday 23rd April 2024)"
	revision: "1"

class
	EL_SSH_COMMAND_FACTORY

inherit
	ANY

	EL_STRING_GENERAL_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (a_ssh_name: READABLE_STRING_GENERAL)
		require
			valid_name: a_ssh_name.count >= 7 and then (4 |..| (a_ssh_name.count - 3)).has (a_ssh_name.index_of ('@', 1))
		do
			ssh_name := as_zstring (a_ssh_name)
		end

feature -- Access

	ssh_name: ZSTRING
		-- defines ssh remote username and address
		-- eg. john@75.34.211.13

feature -- Basic operations

	make_remote_dir (dir_path: DIR_PATH)
		-- ensure remote destination exists
		do
			if not new_test_directory (dir_path).exists and then attached new_make_directory (dir_path) as cmd then
				cmd.execute
			end
		end

feature -- Commands

	new_copy_files  (a_source_files, a_destination_path: DIR_PATH): EL_RSYNC_COMMAND_I
		-- mirror local set of files on remote host using Unix rsync command
		-- `a_source_files.base' may contain a wildcard operator, `*.txt' for example
		do
			Result := new_mirror_directory (a_source_files, a_destination_path)
			Result.update.enable
		end

	new_file_copy (destination_dir: DIR_PATH): EL_SSH_COPY_COMMAND
		-- copy a single file to remote `destination_dir' using Unix `scp' ssh command
		do
			create Result.make (ssh_name)
			Result.set_destination_dir (destination_dir)
		end

	new_make_directory (target_dir: DIR_PATH): EL_SSH_MAKE_DIRECTORY_COMMAND
		do
			create Result.make (ssh_name)
			Result.set_target_dir (target_dir)
		end

	new_md5_hash (target_path: FILE_PATH): EL_SSH_MD5_HASH_COMMAND
		do
			create Result.make (ssh_name)
			Result.set_target_path (target_path)
		end

	new_mirror_directory  (a_source_path, a_destination_path: DIR_PATH): EL_RSYNC_COMMAND_I
		-- mirror local directory tree on remote host using Unix rsync command
		do
			create {EL_RSYNC_COMMAND_IMP} Result.make_ssh (ssh_name, a_source_path, a_destination_path)
			Result.archive.enable
			Result.compress.enable
			Result.delete.enable
			Result.verbose.enable
			Result.progress.enable
		end

	new_test_directory (target_dir: DIR_PATH): EL_SSH_TEST_DIRECTORY_COMMAND
		-- ssh command to test for existence of directory on remote host
		do
			create Result.make (ssh_name)
			Result.set_target_dir (target_dir)
		end

end