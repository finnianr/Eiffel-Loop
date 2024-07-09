note
	description: "Mirror local to remote directory using Unix **lftp** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:15:19 GMT (Tuesday 9th July 2024)"
	revision: "10"

class
	EL_FTP_MIRROR_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [host, user, passphrase, source_dir, target_dir: STRING]]
		redefine
			make, set_source_dir, set_target_dir
		end

	EL_SHARED_ESCAPE_TABLE

create
	 make

feature {NONE} -- Initialization

	make (config: EL_FTP_MIRROR_BACKUP)
		do
			Precursor (config)
			put_string (Var.host, config.host)
			put_string (Var.user, config.user)
			put_string (var.passphrase, config.passphrase.escaped (Bash_escaper))
		end

feature -- Element change

	set_source_dir (source_dir: DIR_PATH)
		do
			-- Don't use `put_path' because target $TARGET_DIR is in quotes
			put_string (var.source_dir, source_dir.to_string)
		end

	set_target_dir (target_dir: DIR_PATH)
		do
			-- Don't use `put_path' because target $TARGET_DIR is in quotes
			put_string (var.target_dir, target_dir.to_string)
		end

feature {NONE} -- Constants

	Bash_escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.Bash)
		end

	Default_template: STRING = "[
		lftp -c "open $HOST; user '$USER' '$PASS'; set ftp:passive-mode true;
		mirror --reverse --verbose '$SOURCE_DIR' '$TARGET_DIR';
		bye"
	]"

end