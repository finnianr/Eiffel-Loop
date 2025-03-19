note
	description: "[
		File synchronization with Unix [https://linux.die.net/man/1/rsync rsync]
		Files can be synchronized either locally or remotely via [https://linux.die.net/man/1/ssh ssh]
	]"
	notes: "[
		For remote transfer by [https://linux.die.net/man/1/ssh ssh] use ${EL_SSH_COMMAND_FACTORY}.new_mirror_directory
		and `new_copy_files' to create an instance.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-16 7:12:41 GMT (Sunday 16th March 2025)"
	revision: "18"

deferred class
	EL_RSYNC_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I
		rename
			set_destination_path as set_destination_dir
		redefine
			execute, getter_function_table, make_default
		end

	EL_SECURE_SHELL_OS_COMMAND_I
		redefine
			make_default
		end

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make_default
			--
		do
			create exclude_list.make (0)
			Precursor {EL_COPY_TREE_COMMAND_I}
		end

	make_ssh (a_ssh_context: like ssh_context; a_source_path, a_destination_path: DIR_PATH)
		do
			make (a_source_path, a_destination_path)
			ssh_context := a_ssh_context
		end

feature -- Access

	exclude_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		-- file patterns for exclusion from transfer
		-- see --exclude option in rsync man

feature -- Basic operations

	execute
		do
			if exclude_list.count > 0 then
				exclusions_path := new_temporary_file_path ("exclude")
				File_system.make_directory (exclusions_path.parent)
				if attached open (exclusions_path, Write) as file then
					file.put_lines (exclude_list)
					file.close
				end
				Precursor
				File_system.remove_file (exclusions_path)
			else
				Precursor
			end
		end

feature -- Options

	archive: EL_BOOLEAN_OPTION
		-- This is equivalent to -rlptgoD.
		-- It is a quick way of saying you want recursion and want  to  preserve  almost  everything

	compress: EL_BOOLEAN_OPTION
		-- compress files during transfer

	delete: EL_BOOLEAN_OPTION
		-- when enabled deletes extraneous files from destination dirs

	no_links: EL_BOOLEAN_OPTION
		-- when enabled, ignore symbolic links

	progress: EL_BOOLEAN_OPTION
		-- show progress during transfer

	update: EL_BOOLEAN_OPTION
		-- This forces rsync to skip any files which exist on the destination and have a modified time
		-- that is newer than the source file. (If an existing destination file has a modification time
		-- equal to the source file's, it will be updated if the sizes are different.)

	verbose: EL_BOOLEAN_OPTION
		-- This option increases the amount of information you are given during the transfer.

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["destination_path",	agent: ZSTRING do Result := escaped_remote (destination_path) end],
				["enabled_options",	agent: STRING do Result := enabled_options.joined_words end],
				["has_exclusions",	agent: BOOLEAN_REF do Result := (not exclude_list.is_empty).to_reference end]
			>>)
		end

feature {NONE} -- Implementation

	new_boolean_ref_list: EL_ARRAYED_LIST [EL_REFLECTED_BOOLEAN_REF]
		do
			if attached {like new_boolean_ref_list} field_table.query_by_type ({EL_REFLECTED_BOOLEAN_REF}) as list then
				Result := list
			end
		end

	enabled_options: EL_ZSTRING_LIST
		do
			create Result.make (7)
			across new_boolean_ref_list as list loop
				if attached list.item as field and then field.index > 14 -- Exclude `sudo' and `timestamp_preserved'
					and then attached {EL_BOOLEAN_OPTION} field.value (Current) as option
					and then option.is_enabled
				then
					Result.extend ((hyphen * 2) + field.name)
					Result.last.replace_character ('_', '-')
				end
			end
		end

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		do
			if ssh_context.user_domain.count > 0 then
--				Result := ssh.escaped_re (a_path)
			else
				Result := a_path.escaped
			end
		end

feature {NONE} -- Internal attributes

	exclusions_path: FILE_PATH

end