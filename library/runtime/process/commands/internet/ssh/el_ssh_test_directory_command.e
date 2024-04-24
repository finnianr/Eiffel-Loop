note
	description: "[
		Test to see if remote directory exists via Unix [https://linux.die.net/man/1/ssh ssh command]
	]"
	notes: "[
		Use ${EL_SSH_COMMAND_FACTORY}.new_test_directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 14:00:51 GMT (Wednesday 24th April 2024)"
	revision: "2"

class
	EL_SSH_TEST_DIRECTORY_COMMAND

inherit
	EL_SSH_DIRECTORY_COMMAND

create
	make

feature -- Status query

	exists: BOOLEAN
		do
			execute
			Result := not has_error
		end

feature {NONE} -- Constants

	Template: STRING = "[
		ssh $USER_DOMAIN "test -d $TARGET_DIR"
	]"

end