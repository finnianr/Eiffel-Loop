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
	date: "2024-07-29 15:06:31 GMT (Monday 29th July 2024)"
	revision: "15"

class
	PROJECT_MANAGER_APP

inherit
	EL_APPLICATION
		redefine
			standard_options, visible_types
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

feature {NONE} -- Implementation

	standard_options: EL_ARRAYED_LIST [EL_COMMAND_LINE_OPTIONS]
		-- Standard command line options
		do
			Result := Precursor + Environment_variable
		end

	visible_types: TUPLE [
		REGULAR_EXPRESSION_SEARCH_COMMAND,
		EL_PYXIS_LOCALE_COMPILER
	]
		do
			create Result
		end

feature {NONE} -- Internal attributes

	shell: PROJECT_MANAGER_SHELL

feature {NONE} -- Constants

	Description: STRING = "Command shell for managing Eiffel project in current directory"

end