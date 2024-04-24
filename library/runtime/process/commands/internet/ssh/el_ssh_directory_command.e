note
	description: "Unix [https://linux.die.net/man/1/ssh ssh command] that operates on a target directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 7:54:18 GMT (Wednesday 24th April 2024)"
	revision: "8"

deferred class
	EL_SSH_DIRECTORY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [user_domain, target_dir: STRING]]
		rename
			make as make_with_template
		end

	EL_SECURE_SHELL_COMMAND

feature -- Access

	target_dir: DIR_PATH
		-- remote directory

feature -- Element change

	set_target_dir (a_target_dir: DIR_PATH)
		do
			target_dir := a_target_dir
			put_remote_path (var.target_dir, a_target_dir)
		end

feature {NONE} -- Implementation

	var_user_domain: STRING
		do
			Result := var.user_domain
		end

end