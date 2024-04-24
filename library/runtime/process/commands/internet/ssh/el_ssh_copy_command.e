note
	description: "[
		Copy single file to remote host using Unix [https://linux.die.net/man/1/scp scp command].
		It uses [https://linux.die.net/man/1/ssh ssh] for data transfer.
	]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_file_copy
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 8:08:02 GMT (Wednesday 24th April 2024)"
	revision: "9"

class
	EL_SSH_COPY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_path, user_domain, destination_dir: STRING]]
		rename
			make as make_with_template
		end

	EL_SECURE_SHELL_COPY_COMMAND

create
	make

feature {NONE} -- Implementation

	var_user_domain: STRING
		do
			Result := var.user_domain
		end

	var_destination_dir: STRING
		do
			Result := var.destination_dir
		end

	var_source_path: STRING
		do
			Result := var.source_path
		end

feature {NONE} -- Constants

	Template: STRING = "scp $SOURCE_PATH $USER_DOMAIN:$DESTINATION_DIR"
end