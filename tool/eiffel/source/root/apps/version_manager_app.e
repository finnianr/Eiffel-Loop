note
	description: "Command line interface to [$source VERSION_MANAGER_SHELL_COMMAND]"
	notes: "[
		USAGE
			el_eiffel -version_manager
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-04 15:37:07 GMT (Saturday 4th March 2023)"
	revision: "11"

class
	VERSION_MANAGER_APP

inherit
	EL_APPLICATION

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create shell.make
		end

feature -- Basic operations

	run
		do
			shell.run_command_loop
		end

feature {NONE} -- Internal attributes

	shell: VERSION_MANAGER_SHELL_COMMAND

feature {NONE} -- Constants

	Description: STRING = "Command shell for bumping project version number"

end