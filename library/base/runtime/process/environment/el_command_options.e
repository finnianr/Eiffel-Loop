note
	description: "Summary description for {EL_COMMAND_OPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-12-14 11:08:27 GMT (Wednesday 14th December 2016)"
	revision: "3"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Silent: STRING = "silent"

	No_app_header: STRING = "no_app_header"

	Help: STRING = "help"

	Install: STRING = "install"

end
