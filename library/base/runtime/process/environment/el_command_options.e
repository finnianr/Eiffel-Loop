note
	description: "Summary description for {EL_COMMAND_OPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 11:29:44 GMT (Monday 3rd October 2016)"
	revision: "2"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Console_on: STRING = "console_on"

	Help: STRING = "help"

	Install: STRING = "install"

end
