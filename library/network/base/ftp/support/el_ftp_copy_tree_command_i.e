note
	description: "[
		Copy local to remote directory with the Unix [https://linux.die.net/man/1/lftp lftp command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:33:07 GMT (Friday 28th March 2025)"
	revision: "1"

deferred class
	EL_FTP_COPY_TREE_COMMAND_I

inherit
	EL_MIRROR_TREE_COMMAND_I
		rename
			make_backup as make_tree_backup
		redefine
			getter_function_table
		end

	EL_SHARED_ESCAPE_TABLE

feature {NONE} -- Initialization

	make_backup (config: EL_FTP_MIRROR_BACKUP; target_dir_base: ZSTRING)
		do
			make_default
			destination_path := config.backup_dir #+ target_dir_base
			host := config.host; user := config.user passphrase := config.passphrase
		end

feature -- Access

	host: STRING

	passphrase: ZSTRING

	user: ZSTRING

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["pass",					agent: ZSTRING do Result := passphrase.escaped (Bash_escaper) end],
				["source_path",		agent: ZSTRING do Result := source_path end], -- unescaped path
				["destination_path",	agent: ZSTRING do Result := destination_path end] -- unescaped path
			>>)
		end

feature {NONE} -- Constants

	Bash_escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.Bash)
		end

end