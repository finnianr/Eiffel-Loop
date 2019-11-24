note
	description: "Some standard command-line word options for Eiffel-Loop"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 11:58:13 GMT (Sunday 24th November 2019)"
	revision: "12"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Help: STRING = "help"

	No_app_header: STRING = "no_app_header"

	No_highlighting: STRING = "no_highlighting"
		-- turns off logging color highlighting

	Silent: STRING = "silent"

feature -- Sub-application options

	Install: STRING = "install"

	Remove_data: STRING = "remove_data"

	Uninstall: STRING = "uninstall"

end
