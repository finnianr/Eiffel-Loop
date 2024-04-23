note
	description: "Unix ''ssh'' command that operates on a target directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 12:13:11 GMT (Tuesday 23rd April 2024)"
	revision: "7"

deferred class
	EL_SSH_DIRECTORY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [user_domain, target_dir: STRING]]
		rename
			make as make_with_template
		end

	EL_SECURE_SHELL_COMMAND
		rename
			set_destination_dir as set_target_dir,
			destination_dir as target_dir
		end

feature {NONE} -- Implementation

	var_index: TUPLE [source_path, user_domain, target_dir: INTEGER]
		do
			Result := [0, 1, 2]
		end

end