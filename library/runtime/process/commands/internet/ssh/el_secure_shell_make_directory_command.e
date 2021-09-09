note
	description: "Make remote directory via Unix ''ssh'' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:48:42 GMT (Thursday 9th September 2021)"
	revision: "3"

class
	EL_SECURE_SHELL_MAKE_DIRECTORY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [user_domain, target_dir: STRING]]
		redefine
			make_default
		end

	EL_SECURE_SHELL_COMMAND
		redefine
			set_user_domain
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		end

feature -- Element change

	set_target_dir (target_dir: EL_DIR_PATH)
		do
			command_template.set_variable (var.target_dir, escaped_remote (target_dir))
		end

	set_user_domain (a_user_domain: ZSTRING)
		do
			Precursor (a_user_domain)
			put_string (var.user_domain, a_user_domain)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $user_domain "mkdir -p $target_dir"
	]"

end