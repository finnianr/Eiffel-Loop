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
	date: "2024-07-09 8:55:58 GMT (Tuesday 9th July 2024)"
	revision: "11"

class
	EL_SSH_COPY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_path, user_domain, destination_dir: STRING]]
		rename
			make as make_with_template
		redefine
			default_template
		end

	EL_SECURE_SHELL_COMMAND

create
	make

feature -- Access

	destination_dir: DIR_PATH

	source_path: EL_PATH

feature -- Element change

	set_destination_dir (a_destination_dir: DIR_PATH)
		do
			destination_dir := a_destination_dir
			put_remote_path (var.destination_dir, a_destination_dir)
		end

	set_source_path (a_source_path: EL_PATH)
		do
			source_path := a_source_path
			put_path (var.source_path, a_source_path)
		end

feature {NONE} -- Implementation

	var_user_domain: STRING
		do
			Result := var.user_domain
		end

feature {NONE} -- Constants

	Default_template: STRING = "scp $SOURCE_PATH $USER_DOMAIN:$DESTINATION_DIR"
end