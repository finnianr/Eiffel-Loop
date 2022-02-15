note
	description: "[
		Remote file synchronization using [https://linux.die.net/man/1/rsync rsync]
		
		if `user_domain' is set then transfers over ssh connection
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 14:00:59 GMT (Tuesday 15th February 2022)"
	revision: "8"

deferred class
	EL_FILE_SYNC_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I
		redefine
			execute, getter_function_table, make_default
		end

	EL_SECURE_SHELL_COMMAND
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

	exclude_list: EL_ZSTRING_LIST
		-- file patterns for exclusion from transfer
		-- see --exclude option in rsync man

feature -- Basic operations

	execute
		do
			exclusions_path := new_temporary_file_path ("exclude")
			if attached open (exclusions_path, Write) as file then
				file.put_lines (exclude_list)
				file.close
			end
			Precursor
			File_system.remove_file (exclusions_path)
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

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		do
			if user_domain.count > 0 then
				Result := Precursor (a_path)
			else
				Result := a_path.escaped
			end
		end

feature {NONE} -- Internal attributes

	exclusions_path: FILE_PATH

end