note
	description: "[
		Obtain MD5 hash of remote file using Unix [https://linux.die.net/man/1/md5sum md5sum command]
		remotely invoked via [https://linux.die.net/man/1/ssh ssh command].
	]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_md5_digest and `new_md5_binary_digest'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-06 8:39:46 GMT (Thursday 6th March 2025)"
	revision: "5"

class
	EL_SSH_MD5_HASH_COMMAND

inherit
	EL_SECURE_SHELL_COMMAND

	EL_PARSED_OS_COMMAND [TUPLE [user_domain, mode, target_path: STRING]]
		rename
			make as make_with_template
		undefine
			is_captured, do_command, new_command_parts, reset
		redefine
			default_template, make_with_template
		end

	EL_MD5_HASH_COMMAND
		rename
			make as make_with_template,
			Var as MD5_var
		undefine
			execute, make_command, make_default, default_name, make_with_template, valid_tuple
		redefine
			set_target_path
		end

create
	make

feature {NONE} -- Implementation

	make_with_template
		do
			Precursor {EL_PARSED_OS_COMMAND}
			check
				same_variable_names: MD5_var.mode ~ Var.mode and MD5_var.target_path ~ Var.target_path
			end
			set_text
		end

feature -- Element change

	set_target_path (a_target_path: FILE_PATH)
		do
			target_path := a_target_path
			put_remote_path (var.target_path, a_target_path)
		end

feature {NONE} -- Implementation

	var_user_domain: STRING
		do
			Result := var.user_domain
		end

feature {NONE} -- Constants

	Default_template: STRING = "[
		ssh $USER_DOMAIN "md5sum --$MODE $TARGET_PATH"
	]"

end