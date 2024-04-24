note
	description: "Make remote directory via Unix [https://linux.die.net/man/1/ssh ssh command]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_make_directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 7:35:40 GMT (Wednesday 24th April 2024)"
	revision: "8"

class
	EL_SSH_MAKE_DIRECTORY_COMMAND

inherit
	EL_SSH_DIRECTORY_COMMAND

create
	make

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $USER_DOMAIN "mkdir -p $TARGET_DIR"
	]"

end