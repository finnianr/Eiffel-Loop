note
	description: "Wrapper for Unix ''scp'' command"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_file_copy
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 12:12:58 GMT (Tuesday 23rd April 2024)"
	revision: "8"

class
	EL_SSH_COPY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_path, user_domain, destination_dir: STRING]]
		rename
			make as make_with_template
		end

	EL_SECURE_SHELL_COMMAND

create
	make

feature {NONE} -- Implementation

	var_index: TUPLE [source_path, user_domain, destination_dir: INTEGER]
		do
			Result := [1, 2, 3]
		end

feature {NONE} -- Constants

	Template: STRING = "scp $SOURCE_PATH $USER_DOMAIN:$DESTINATION_DIR"
end