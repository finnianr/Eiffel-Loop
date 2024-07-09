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
	date: "2024-07-09 9:14:10 GMT (Tuesday 9th July 2024)"
	revision: "3"

class
	EL_SSH_TEST_DIRECTORY_COMMAND

inherit
	EL_SSH_DIRECTORY_COMMAND
		redefine
			default_template
		end

create
	make

feature -- Status query

	exists: BOOLEAN
		do
			execute
			Result := not has_error
		end

feature {NONE} -- Constants

	Default_template: STRING = "[
		ssh $USER_DOMAIN "test -d $TARGET_DIR"
	]"

end