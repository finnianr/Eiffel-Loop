note
	description: "Command line interface to ${PROJECT_MANAGER_SHELL}"
	notes: "[
		USAGE
			el_eiffel -project_manager
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	PROJECT_MANAGER_APP

inherit
	EL_APPLICATION
		redefine
			visible_types
		end

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

	shell: PROJECT_MANAGER_SHELL

feature {NONE} -- Implementation

	visible_types: TUPLE [
		REGULAR_EXPRESSION_SEARCH_COMMAND
--		EIFFEL_GREP_COMMAND
	]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Command shell for managing Eiffel project in current directory"

end