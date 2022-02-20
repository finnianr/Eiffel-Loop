note
	description: "Wrapper for Unix ''scp'' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 10:27:24 GMT (Sunday 20th February 2022)"
	revision: "6"

class
	EL_SSH_COPY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_path, user_domain, destination_dir: STRING]]

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