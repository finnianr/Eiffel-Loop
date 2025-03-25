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
	date: "2025-03-25 18:59:10 GMT (Tuesday 25th March 2025)"
	revision: "21"

deferred class
	EL_RSYNC_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I
		rename
			set_destination_path as set_destination_dir
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

	make_default
			--
		do
			create exclude_list.make (0)
			Precursor {EL_COPY_TREE_COMMAND_I}
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
			Result := Precursor {EL_COPY_TREE_COMMAND_I}
			Result.merge (Precursor {EL_SECURE_SHELL_OS_COMMAND})

			Result.append_tuples (<<
				["destination_path",	agent: ZSTRING do Result := destination_path.escaped end],
				["enabled_options",	agent: STRING do Result := enabled_options.joined_words end],
				["has_exclusions",	agent: BOOLEAN_REF do Result := (not exclude_list.is_empty).to_reference end]
			>>)
		end

feature {NONE} -- Implementation

	enabled_options: EL_STRING_8_LIST
		do
			if attached option_list.query_if (agent {EL_BOOLEAN_OPTION}.is_enabled) as enabled_list then
				create Result.make (enabled_list.count)
				across field_list.name_list_for (Current, enabled_list) as list loop
					Result.extend (option_name (list.item))
				end
			end
		end

	option_name (name: IMMUTABLE_STRING_8): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := hyphen * 2 + name
			s.replace_character (Result, '_', '-') -- no-links
		end

	option_list: EL_ARRAYED_LIST [EL_BOOLEAN_OPTION]
		do
			create Result.make_from_array (<< archive, compress, delete, no_links, progress, update, verbose >>)
		end

feature {NONE} -- Internal attributes

	exclusions_path: FILE_PATH

end