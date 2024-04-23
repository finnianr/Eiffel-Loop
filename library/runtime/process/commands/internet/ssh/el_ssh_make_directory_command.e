note
	description: "Make remote directory via Unix ''ssh'' command"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_make_directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 11:27:43 GMT (Tuesday 23rd April 2024)"
	revision: "7"

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