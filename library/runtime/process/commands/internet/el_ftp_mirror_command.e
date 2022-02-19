note
	description: "Mirror local to remote directory using Unix **lftp** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 16:44:31 GMT (Saturday 19th February 2022)"
	revision: "2"

class
	EL_FTP_MIRROR_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [host, user, passphrase, source_dir, target_dir: STRING]]

create
	 make

feature -- Element change

	set_host_name (host_name: STRING)
		do
			put_string (var.host, host_name)
		end

	set_passphrase (passphrase: ZSTRING)
		do
			put_string (var.passphrase, passphrase.escaped (Bash_escaper))
		end

	set_source_dir (source_dir: DIR_PATH)
		do
			put_string (var.source_dir, source_dir)
		end

	set_target_dir (target_dir: DIR_PATH)
		do
			put_path (var.target_dir, target_dir)
		end

	set_user (user: ZSTRING)
		do
			put_string (var.user, user)
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