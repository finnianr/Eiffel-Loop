note
	description: "[
		Make remote directory via Unix [https://man7.org/linux/man-pages/man1/mkdir.1.html mkdir command]
		in conjunction with [https://linux.die.net/man/1/ssh ssh]
	]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_make_directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 14:03:34 GMT (Wednesday 24th April 2024)"
	revision: "9"

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