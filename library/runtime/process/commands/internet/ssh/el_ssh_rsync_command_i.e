note
	description: "[
		Remote file synchronization using [https://linux.die.net/man/1/rsync rsync]
		
		if `user_domain' is set then transfers over ssh connection
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 9:57:24 GMT (Wednesday 28th December 2022)"
	revision: "13"

deferred class
	EL_SSH_RSYNC_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I
		rename
			set_destination_path as set_destination_dir
		redefine
			execute, getter_function_table, make_default
		end

	EL_SECURE_SHELL_COMMAND
		undefine
			set_source_path, set_destination_dir
		redefine
			escaped_remote
		end

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make_default
			--
		do
			create exclude_list.make (0)
			Precursor
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

	verbose: EL_BOOLEAN_OPTION
		-- This option increases the amount of information you are given during the transfer.

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["destination_path",	agent: ZSTRING do Result := escaped_remote (destination_path) end] +
				["has_exclusions",	agent: BOOLEAN_REF do Result := (not exclude_list.is_empty).to_reference end] +
				["user_domain",		agent: ZSTRING do Result := user_domain end]
		end

feature {NONE} -- Implementation

	var_index: TUPLE [source_path, user_domain, destination_dir: INTEGER]
		do
			Result := [0, 0, 0]
		end

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		do
			if user_domain.count > 0 then
				Result := Precursor (a_path)
			else
				Result := a_path.escaped
			end
		end

	put_path_variable (index: INTEGER; a_path: EL_PATH)
		-- Not applicable
		do
		end

	put_string_variable (index: INTEGER; value: READABLE_STRING_GENERAL)
		-- Not applicable
		do
		end

feature {NONE} -- Internal attributes

	exclusions_path: FILE_PATH

end