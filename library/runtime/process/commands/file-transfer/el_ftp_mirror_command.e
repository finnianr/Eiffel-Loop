note
	description: "Mirror local to remote directory using Unix **lftp** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_FTP_MIRROR_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [host, user, passphrase, source_dir, target_dir: STRING]]
		redefine
			set_passphrase, set_source_dir, set_target_dir
		end

create
	 make

feature -- Element change

	set_passphrase (passphrase: ZSTRING)
		do
			put_string (var.passphrase, passphrase.escaped (Bash_escaper))
		end

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

feature {NONE} -- Implementation

	var_index: TUPLE [host, user, passphrase, source_dir, target_dir: INTEGER]
		do
			Result := [1, 2, 3, 4, 5]
		end

feature {NONE} -- Constants

	Bash_escaper: EL_BASH_PATH_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Template: STRING = "[
		lftp -c
		"open $HOST; user '$USER' '$PASS'; mirror --reverse --verbose '$SOURCE_DIR' '$TARGET_DIR'; bye"
	]"

end