note
	description: "Command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 9:10:58 GMT (Tuesday 19th June 2018)"
	revision: "7"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Help: STRING = "help"

	Install: STRING = "install"

	No_app_header: STRING = "no_app_header"

	No_highlighting: STRING = "no_highlighting"
		-- turns off logging color highlighting

	Silent: STRING = "silent"

	Uninstall: STRING = "uninstall"

end
