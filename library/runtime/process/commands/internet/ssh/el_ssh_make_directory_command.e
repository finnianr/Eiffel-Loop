note
	description: "Make remote directory via Unix ''ssh'' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_SSH_MAKE_DIRECTORY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [user_domain, target_dir: STRING]]
		redefine
			make_default
		end

	EL_SECURE_SHELL_COMMAND
		rename
			set_destination_dir as set_target_dir,
			destination_dir as target_dir
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		end

feature {NONE} -- Implementation

	var_index: TUPLE [source_path, user_domain, target_dir: INTEGER]
		do
			Result := [0, 1, 2]
		end

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $USER_DOMAIN "mkdir -p $TARGET_DIR"
	]"

end