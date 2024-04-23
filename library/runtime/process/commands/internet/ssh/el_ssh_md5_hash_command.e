note
	description: "[
		Obtain MD5 hash of remote file using Unix [https://linux.die.net/man/1/md5sum md5sum command]
		remotely invoked via [https://linux.die.net/man/1/ssh ssh command].
	]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_md5_hash
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 17:21:51 GMT (Tuesday 23rd April 2024)"
	revision: "1"

class
	EL_SSH_MD5_HASH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [mode, user_domain, target_path: STRING]]
		rename
			make as make_with_template
		undefine
			is_captured, do_command, new_command_parts, reset
		redefine
			make_with_template
		end

	EL_SECURE_SHELL_COMMAND
		rename
			set_destination_dir as set_target_dir,
			set_source_path as set_mode_path,
			destination_dir as target_dir
		export
			{NONE} set_target_dir, target_dir, set_mode_path
		redefine
			make_with_template
		end

	EL_MD5_HASH_COMMAND
		rename
			make as make_md5,
			template as command_template,
			Var as MD5_var
		undefine
			execute, make_default, default_name, make_command, valid_tuple
		redefine
			set_mode, set_target_path
		end

create
	make

feature {NONE} -- Implementation

	make_with_template
		do
			Precursor
			set_text_mode
		end

feature -- Element change

	set_target_path (a_target_path: FILE_PATH)
		do
			target_path := a_target_path
			create target_dir.make_from_other (a_target_path)
			set_target_dir (target_dir)
		end

feature {NONE} -- Implementation

	set_mode (mode: STRING)
		do
			set_mode_path (create {DIR_PATH}.make (mode))
		end

	var_index: TUPLE [mode, user_domain, target_path: INTEGER]
		do
			Result := [2, 1, 3]
		end

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $USER_DOMAIN "md5sum --$MODE $TARGET_PATH"
	]"

end