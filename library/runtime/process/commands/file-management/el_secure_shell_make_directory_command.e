note
	description: "Make remote directory via Unix ''ssh'' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-20 14:30:25 GMT (Friday 20th August 2021)"
	revision: "1"

class
	EL_SECURE_SHELL_MAKE_DIRECTORY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [user_domain, target_dir: STRING]]

create
	make

feature -- Element change

	set_target_dir (target_dir: EL_DIR_PATH)
		local
			l_path: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			l_path := target_dir.escaped
			-- double escape backslash
			l_path.replace_substring_all (s.character_string ('\'), s.n_character_string ('\', 2))
			command_template.set_variable (var.target_dir, l_path)
		end

	set_user_domain (user_domain: ZSTRING)
		do
			put_string (var.user_domain, user_domain)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $user_domain "mkdir -p $target_dir"
	]"

end