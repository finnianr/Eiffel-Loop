note
	description: "[
		File synchronization with Unix [https://linux.die.net/man/1/rsync rsync]
		Files can be synchronized either locally or remotely via [https://linux.die.net/man/1/ssh ssh]
	]"
	notes: "[
		For remote transfer by [https://linux.die.net/man/1/ssh ssh] use ${EL_SSH_COMMAND_FACTORY}.new_mirror_directory
		and `new_copy_files' to create an instance.
		
		`source_path.base' may contain a wildcard operator, `*.txt' for example
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 11:12:27 GMT (Monday 31st March 2025)"
	revision: "26"

deferred class
	EL_RSYNC_COMMAND_I

inherit
	EL_MIRROR_TREE_COMMAND_I
		redefine
			execute, getter_function_table, make_default
		end

	EL_SECURE_SHELL_OS_COMMAND
		redefine
			getter_function_table
		end

	EL_FILE_OPEN_ROUTINES

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make_ssh_backup (config: EL_SSH_MIRROR_BACKUP)
		do
			make_backup (config)
			set_ssh_context (create {EL_SECURE_SHELL_CONTEXT}.make (config.user_host))
		end

	make_default
			--
		do
			create exclude_list.make (0)
			Precursor {EL_MIRROR_TREE_COMMAND_I}
		end

feature -- Access

	exclude_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		-- file patterns for exclusion from transfer
		-- see --exclude option in rsync man

	source_file_path: FILE_PATH

feature -- Status query

	make_remote_dir: EL_BOOLEAN_OPTION

feature -- Status change

	enable_all_except (exception_list: ARRAY [EL_BOOLEAN_OPTION])
		require
			valid_options: across exception_list as list all option_list.has (list.item) end
		do
			across option_list as list loop
				list.item.set_state (not exception_list.has (list.item))
			end
		end

feature -- Option groups

	enabled_option_list: EL_ARRAYED_LIST [EL_BOOLEAN_OPTION]
		-- enabled rsync options
		do
			create Result.make_from_if (option_list, agent {EL_BOOLEAN_OPTION}.is_enabled)
		end

	option_list: ARRAY [EL_BOOLEAN_OPTION]
		-- all rsync options
		do
			Result := << archive, compress, delete, no_links, progress, update, verbose >>
		ensure
			seven: Result.count = 7
		end

feature -- Options for rsync

	archive: EL_BOOLEAN_OPTION
		-- This is equivalent to -rlptgoD.
		-- It is a quick way of saying you want recursion and want to preserve almost everything

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

feature -- Element change

	set_source_file_path (a_source_file_path: FILE_PATH)
		do
			source_file_path := a_source_file_path
			source_path.set_path (a_source_file_path.to_string)
		end

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

feature {NONE} -- Evolicity reflection

	get_trailing_slash: CHARACTER_8_REF
		-- '/' if `source_file_path' is not empty else ' '
		do
			if source_file_path.is_empty then
				Result := ' '
			else
				Result := '/'
			end
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_MIRROR_TREE_COMMAND_I}
			Result.merge (Precursor {EL_SECURE_SHELL_OS_COMMAND})

			Result.append_tuples (<<
				["enabled_options",	  agent: STRING do Result := enabled_options.as_word_string end],
				["has_exclusions",	  agent: BOOLEAN_REF do Result := (not exclude_list.is_empty).to_reference end],
				["destination_parent", agent: ZSTRING do Result := destination_path.parent.escaped end],
				["trailing_slash",	  agent get_trailing_slash]
			>>)
		end

feature {NONE} -- Implementation

	enabled_options: EL_STRING_8_LIST
		local
			option_name: STRING
		do
			if attached enabled_option_list as enabled_list then
				create Result.make (enabled_list.count)
				across field_list.name_list_for (Current, enabled_list) as list loop
					option_name := hyphen * 2 + list.item
					super_8 (option_name).replace_character ('_', '-') -- no-links
					Result.extend (option_name)
				end
			end
		end

feature {NONE} -- Internal attributes

	exclusions_path: FILE_PATH

end